---

title: github-filebrowser-turbo-html
date: 2021-04-04 17:13 UTC
tags: book, file-browser, chapter-1

---

# Building a GitHub File Browser in Turbo

## Introducing `pjax`

One of the predessors of "Hot Way" thinking and a familiar interface is the GitHub File Browser. In order to make navigating through the various folders and files of a Git repository, GitHub implemented a pattern dubbed "PJAX"

> pjax works by fetching HTML from your server via ajax and replacing the content of a container element on your page with the loaded HTML. It then updates the current URL in the browser using pushState. This results in faster page navigation for two reasons:
>
>- No page resources (JS, CSS) get re-executed or re-applied;
>
>- If the server is configured for pjax, it can render only partial page contents and thus avoid the potentially costly full layout render.

[jquery-pjax](https://github.com/defunkt/jquery-pjax)

Consider first the functionality required to build a file bronwser interface. Every folder and file in a tree would need at leasts the following:

1. A click event to request the data, most likely in JSON, from the server for the next tree of files.
2. Build new HTML for the file tree using the JSON from the server.
3. Replace the stale file tree with the newly constructed HTML.
4. Maintain an accurate URL of the current working path using pushState.

Rather than implement such custom logic for a common pattern of updating a part of a page with new HTML based on data from the server, defunkt chose to abstract this into the pjax pattern. With pjax, instead of requesting only structured JSON data from the server and then having to teach the client what to do with that raw data, the client would simply request HTML from the server and inject it back into the page in the correct location. This approach is simpler for a few reasons:

1. The backend can remain client-agnostic and send back HTML for the file tree without the need to implement both an initial page load of HTML response and a JSON API response for the client-side AJAX requests.
2. The view logic of how to render the file browser HTML remains singular, defined in the backend and not reimplemented through Javascript templates that convert JSON into HTML. 
3. The pattern is re-usable and abstract, you do not need to build specific client-side code for common page updates.

`pjax` was quickly adopted by the Rails community and eventually became the basis for the `turbolinks` pattern. The majority of page loads in a Rails application could make the request using AJAX, get the HTML for the next page asynchronously, and replace the entire `body` of the current view with the `body` from the AJAX request, while maintaining an accurate URL using pushState. Of course, if pjax was the predessor pattern for turbolinks, it is also the basis for turbo frames.

## Defining the file browser turbo frames

The first part of implementing an interface using turbo frames is to define the sections of the page to be updated independently. `pjax` basically treats the entire `body` of your page as one big frame and updates it upon every request. a `turbo frame` gives you more granular control (without the need to rewrite your backend to support JSON apis or to reimplement templates).

For the file browser interface, let's start by defining a singular frame for both the file tree and any file content.