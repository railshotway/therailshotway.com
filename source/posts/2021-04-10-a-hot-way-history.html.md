---
title: 'A Hot Way History'
date: 2021-04-10 19:44 UTC
author: avi_flombaum
tags:
  - history
  - ajax
  - pjax
  - philosophy
---

# A Hot Way History

## AJAX and the Birth of Web Applications

The early world wide web was composed of interlinking documents. The browser as a medium primarly delivered HTML documents that were concerned mostly with text. The web platform was an incredible way to share and consume information in the form of hypertext delivered over HTTP. Functionality on the other hand, things like games, communication applications like email, office software such as spreadsheets, still lived on the PC platform. If you wanted a program, you had to install it onto your PC.

Web developers tried to break the browser free of the confines of documents and into the world of applications but it didn't work. Interactions were slow, and not just because we didn't have easy access to blazing broadband options, but because every time you wanted to do something in the browser, the entire browser would need to be reloaded with a new HTTP round trip. During this loading time, the interface was locked and you couldn't do anything. That means every link click, every form submission, had to happen synchronously, you could do one thing, but then you had to wait for the browser to make a request and the server to respond. 

>Desktop applications have a richness and responsiveness that has seemed out of reach on the Web. The same simplicity that enabled the Web’s rapid proliferation also creates a gap between the experiences we can provide and the experiences users can get from a desktop application. 
> Jesse James Garrett, February 18 2005

Despite early failures, developers continued trying to push the boundries of the browser medium. After all, the browser and the web held a lot of promise as an application paltform. The web browser application had become ubiquitos with nearly every PC regardless of operating system having an installed browser. The proposition to be able to deliver application functionality through the browser and via HTTP was very compelling. Early attempts at this relied on Macromedia Flash and Java Applets running within the browser through plugins. The Flash and Applet environments allowed for the dynamic and rich interactions demanded by applications. However, for a variety of reasons, those in-browser platforms failed to achieve the adoption of common web browser document experiences. The most popular web destinations remained as HTML document with limited and slow interactivity.

And then in Febuary 2004, things began changing. Apple added something developed by Microsoft for Internet Explorer, the `XMLHttpRequest` object, as a standard component accessible through a Javascript. The `XMLHttpRequest` was originally part of Microsoft's MSXML and ActiveX browser extensions. The `XMLHttpRequest` object allowed programmers to initiate asynchronous HTTP requests that did not lock the browser interface. Once adopted by Safar and given a Javascript API, the world began to slowly see web sites that functioned more and more like desktop applications. It happened slowly at first, interfaces that included "type-ahead" autocomplete and suggestions. Pages that could update with new information without any user-driven event like new updates. And all of these cool new user-interfaces and abilities didn't require a plugin download. What was going on? On February 18 2005 the pattern was reversed-engineered, defined, coined, and explained to the world in one of the most important blog posts in web development history, the seminile [Ajax: A New Approach to Web Applications](https://hotway.s3.us-east-1.amazonaws.com/ajax/Ajax%20-%20A%20New%20Approach%20to%20Web%20Applications.pdf) by Jesse James Garrett.

![AJAX Figure 1](https://hotway.s3.us-east-1.amazonaws.com/ajax/ajax-figure-1.jpg)
![AJAX Figure 2](https://hotway.s3.us-east-1.amazonaws.com/ajax/ajax-figure-2.jpg)


By using the `XMLHttpRequest` object, developers could ferry data back and forth from the browser to the server without locking the browser in a full reload. This allowed web developers to deliver rich, dynamic, interfaces and experiences previously locked to the desktop. The web as a true platform was born and "web sites" evolved into "web applications."

## XML and JSON

In order to use AJAX, developers would use Javascript to fire `XMLHttpRequest`s to the server on any data update. The server would respond with the data in structured format, generally XML or the newly introduced [JSON](https://www.json.org/json-en.html), created by Doug Crockford. The tag-based XML format was considered bloated for HTTP and JSON afford a lightweight alternative. Since the data was going to be needed to be parsed and used to modify the HTML document through the Javascript DOM API anyway, the fact that JSON was natively compatible with Javascript reduced encoding and decoding issues. XML quickly lost favor among web developers building AJAX applications. The defacto web application pattern became:

1. Client-side Javascript fires an XMLHttpRequest.
2. The server responds with JSON.
3. Javascript on the client uses the JSON to modify the page.

The proliferation of this pattern and the complex interactions and interfaces it allowed gave rise to another problem. The amount of client-side javascript being written grew and grew and the Javascript ecosystem was immature. Libraries like jQuery and early frontend frameworks like Backbone.js sought to make the task of writing dynamic web application interfaces easier but it was a mess for a good amount of time.

## `pjax` and HTML

While the AJAX pattern mostly relied on sending back raw structured data to the client and using Javascript to handle the page update, there was another pattern being used. In order to make navigating through the various folders and files of a Git repository, GitHub implemented a pattern dubbed "PJAX"

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

## The Hot Way

> Hotwire is an alternative approach to building modern web applications without using much JavaScript by sending HTML instead of JSON over the wire. This makes for fast first-load pages, keeps template rendering on the server, and allows for a simpler, more productive development experience in any programming language, without sacrificing any of the speed or responsiveness associated with a traditional single-page application.

[Hotwire.dev](https://hotwire.dev)

`pjax` was quickly adopted by the Rails community and eventually became the basis for the `turbolinks` pattern. The majority of page loads in a Rails application could make the request using AJAX, get the HTML for the next page asynchronously, and replace the entire `body` of the current view with the `body` from the AJAX request, while maintaining an accurate URL using pushState. Of course, if pjax was the predessor pattern for turbolinks, it is at the heart of the Turbo pattern and the Hot Way of building web applications.

