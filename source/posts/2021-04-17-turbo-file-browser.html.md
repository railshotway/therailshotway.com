---
title: 'File Browser with Turbo Frames'
date: 2021-04-17 19:44 UTC
author: avi_flombaum
tags:
  - turbo-frames
  - hotwire
  - file-browser
---

I thought it would be interesting to implement the GitHub file browser using turbo frames instead of turbolinks or pjax. It turns out that in trying to implement this interface patter, I discovered some nuances to turbo frames that I thought would be worth sharing.

The code is packaged as a rails app and you can find the relevant example branch [here](https://github.com/railshotway/file-browser/tree/turbo-singular-file-browser-frame). I'm going to focus on the Turbo and Hotwire aspects of this pattern and ignore the Rails backend.

![File Browser](https://p194.p3.n0.cdn.getcloudapp.com/items/xQub7J1y/87dacd6b-d814-4684-95f6-cef3d1e524e6.gif?v=6ddd7ee103e2464502496f5023c6341f)

Each link click within the file browser is navigating the `<turbo-frame id="file-browser">` located within the main [`show.html.erb`](https://github.com/railshotway/file-browser/blob/turbo-singular-file-browser-frame/app/views/file_browsers/show.html.erb) view. 

The relevant parts of the frame code are:

```html
<turbo-frame id="file_browser" data-controller="file-browser"> 
  <div class="row">
    <div class="offset-2 col-8 border-bottom border-start border-end rounded-bottom">
      <% @current_node.children.each do |node| %>
      <div class="row border-top">
        <a href="/turbo_browser/<%= node.path %>" data-action="click->file-browser#navigate">
          <div class="col-12 d-flex align-items-center px-3 py-2">
            <div class="me-3 d-flex align-items-center">
              <%= file_browser_icon(node) %>
            </div>
            <span><%= node.name %></span>
          </div>
        </a>
      </div>
      <% end %>
    </div>
  </div>
</turbo-frame>
```

Each click within the frame will trigger the frame to navigate by updating the frame source. There's some Stimulus interactions wired to the HTML but the truth is, when I first began implementing this example, I didn't think I was going to need to do anything custom.

## How It Should Have Worked

Because the links are within a turbo-frame, they should have natively triggered the frame to navigate. I wouldn't need to change anything about the Rails backend, sending JSON about the file system back instead of HTML, or teaching the Rails controller how to respond to a full page load vs a frame navigation. All of that is part of the Rails Turbo. However, I encountered two subtleties to Turbo and turbo frames.

The first is that when you are navigating a turbo frame, the browser's URL wasn't changing or the history was not being informed about a new state. This is a current discussion within Turbo, with the most relevant discussion centering around this [PR](https://github.com/hotwired/turbo/pull/167).

The second is that when you were clicking on a link that ended in a file extension, like `routes.rb` in the above gif, it was triggering a full page load and not a frame navigation. That is to say, for some reason, links within the file system tree that were folders were working fine, links that were to files were not navigating the frame.

## Maintaining Browser History on Frame Navigation

The first issue is a philosophical one. Should navigating a frame be considered a navigational event that represents a change of state? I think by default, no. The point of turbo frames is that they represent interface components, the vast majority of which would not really represent a navigation state change of the application. However, I think it would be a worthwhile addition to the library to allow a frame to maintain history upon navigation. 

In the file browser example, you can imagine this application having more interface elements (like the real GitHub UI does) and you might want to have those interface elements be independent frames. 

### turbolinks vs turbo-frames

When you're navigating within the file browser interface element, you still would want to treat that as a frame navigation and not drop down to a turbolink. The reason why is because as a turbolink navigational event, the link click would still trigger an AJAX request, but the Rails backend would send back an entire page response and turbolinks would re-render the entire `<body>` of the page. In a complex interface, your forcing the browser to do a lot of work re-rendering the entire interface when really only one component was updated.

By making the file browser interface component a turbo frame, when that frame is navigated, the Rails backend is only sending back the rendered action's view. There response does not include the entire `<html>` of the page but rather just the individual view's html.

![View Response](https://p194.p3.n0.cdn.getcloudapp.com/items/DOuDqLX5/eb430f74-e1c3-414c-b733-b672eb0fd129.jpg?v=97e15f48a8b86acb989b90de9b5655a1)

Rails knew to only send back the view because the request headers referenced a turbo-frame with a value of file-browser. The ajax request knew to include those request headers because the link click originated from within a turbo-frame element.

![Frame Request Headers](https://p194.p3.n0.cdn.getcloudapp.com/items/llu5NeRv/f231bd85-b4c2-4466-8103-e8732180613e.jpg?v=d85a1fa1ee742d28878482d1c11da862)

Navigating within the file tree is easier on the backend and on the frontend. The backend doesn't have to render the `application.html.erb` which is easier on your server especially if there is actually a lot to rendering your application interface. And instead of replacing the entire `<body>` and rebinding the entire interface of your application, the browser only needs to redraw the targeted frame.

### How to Maintain Browser History on Frame Navigation

In this use-case, you would very much want to be able to maintain the browser history upon the navigation of the main file-browser frame. While you are using turbo-frames to get the benefits mentioned above, you still want the frame navigation to be bookmarkable and to really represent a state change in the application and not just the frame.

Until the PR addressing this concern is resolved, I found [two](https://gist.github.com/Intrepidd/ac68cb7dfd17d422374807efb6bf2f42) [nice](https://gist.github.com/Intrepidd/bb1ffc5944a5c1ec3a9f5582753c4b67) examples of how to do this myself. I ended up implementing a combination of the two in a stimulus [file\_browser\_controller.js](https://github.com/railshotway/file-browser/blob/turbo-singular-file-browser-frame/app/javascript/controllers/file_browser_controller.js)

<meta data-controller="callout" data-callout-text-value="import { navigator } from &quot;@hotwired/turbo&quot;">
<meta data-controller="callout" data-callout-text-value="navigator.history.push(new URL(this.element.getAttribute(&quot;src&quot;)))">

```js
import { Controller } from "stimulus"
import { navigator } from "@hotwired/turbo"

export default class extends Controller {
  connect() {
    this.observer = new MutationObserver((mutationsList) => {
      mutationsList.forEach((mutation) => {
        if (mutation.type === "attributes" && mutation.attributeName === "src") {
          navigator.history.push(new URL(this.element.getAttribute("src")))
        }
      })
    })

    this.observer.observe(this.element, { attributes: true })
  }

  disconnect() {
    this.observer.disconnect()
  }
}
```

The controller uses a [MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) on the frame element to observe for changes to the `src` attribute. Whenever the `src` attribute of the frame changes, the [`navigator`](https://github.com/hotwired/turbo/blob/main/src/core/drive/navigator.ts) from `Turbo` is used to push a new state to the browser with the URL from the navigated frame source. Thus, when the frame is navigated, the browser's URL changes.

I loved how native and easy this was to implement. I think it speaks to how composable and properly abstract the Turbo libraries are becoming. 

Want to modify the history of the browser? Great, just use the raw `navigator` object from the library. It wraps nicely around history.pushState.

Navigating a frame isn't isolated to the event that triggered the navigation, in this case a click on a link, but rather is actually represented by the frame's `src` attribute changing. This means that you can observe generically on the frame and say that whenever it's `src` changes, it has been navigated, and thus choose to update the history.

I think it probably makes sense to add a `turbo:frame-navigation` [event](https://turbo.hotwire.dev/reference/events) to make binding to that event easier in the future. But for now, this was simple enough.

## Fixing Frame Navigation on Files

The next issue I encountered was weirder. For some reason, when you were clicking on a file in the file browser, that link click wasn't navigating the frame and would end up navigating the entire application. Not the biggest deal, everything still looked like it worked to the end-user experience. But it was triggering a full page load and I didn't get why a click to `turbo_browser/app` would be treated differently than a click to `turbo_browser/app/routes.rb`. 

I suspected it had to do with the `.rb` and quickly confirmed that by finding the [locationIsVisitable](https://github.com/hotwired/turbo/blob/aae03ada8be4b46899330364d712cc1ae57f2400/src/core/session.ts#L252) function in the Turbo session core. This function relies on [isHTML](https://github.com/hotwired/turbo/blob/aae03ada8be4b46899330364d712cc1ae57f2400/src/core/url.ts#L22) which is basically saying that only trigger Turbo navigation events for links where the extension is `html`, `htm`, or `xhtml`. 

This makes sense as generally links with extensions other than those represent files and clicks to those should be allowed to function normally, like triggering the browser to download the file.

But again, in this use-case, within the file-browser frame, a link click to a URL with an extension should still navigate the frame. So, how could I trigger the frame to navigate on this link click?

### How to Navigate a Turbo Frame

Navigating a turbo frame is as simple as changing the frame's src attribute. Because I already had a Stimulus controller to maintain the browser history on frame navigation, I figured I'd just add a [`navigate()`](https://github.com/railshotway/file-browser/blob/turbo-singular-file-browser-frame/app/javascript/controllers/file_browser_controller.js#L31-L35) function and [trigger that action](https://github.com/railshotway/file-browser/blob/turbo-singular-file-browser-frame/app/views/file_browsers/show.html.erb#L20) on all file path link clicks.

```js
navigate(e){
  e.preventDefault()
  e.stopPropagation()
  this.element.src = e.currentTarget.href
}
```

```html
<a href="/turbo_browser/<%= node.path %>" data-action="click->file-browser#navigate">
```

That ensures that all file paths within the file browser will trigger the file browser frame to navigate to the new file path.

Again, what was so nice is how simple this was to implement. Just add a click event, which could easily be done without Stimulus, find the frame you want to navigate, and change it's source.

Loving the Hot Way.