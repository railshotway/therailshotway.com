---
title: 'How Basecamp Uses Hotwire, Part 1: HEY Loads Frames On-Click'
author: jose_farias
date: 2021-04-02 19:43 UTC
tags:
  - Hotwire
  - Basecamp
  - Hey
---

How Basecamp uses Hotwire: Load frames on click
I reverse engineer Hey so you don't have to
Dont even use rails

<!-- Blank space between meta tag and code block is necessary -->
<meta data-controller="callout" data-callout-text-value="data-loader-url-value=&quot;/highlight-me&quot;">

```html
<div data-controller="loader"
     data-loader-url-value="/highlight-me">
</div>
```

<!-- Consecutive meta tags can target consecutive statements -->
<meta data-controller="callout" data-callout-text-value="data-loader-url-value=&quot;/avoid-this&quot;&gt;" data-callout-type-value="avoid">
<meta data-controller="callout" data-callout-text-value="data-loader-url-value=&quot;/prefer-this&quot;&gt;" data-callout-type-value="prefer">

```html
<div data-controller="loader"
     data-loader-url-value="/avoid-this">
     data-loader-url-value="/prefer-this">
</div>
```

<!-- Notice how meta tags only affect blocks that immidiately follow them,
     the next block has no styling -->

```html
<div data-controller="loader"
     data-loader-url-value="/messages">
</div>
```

<!-- Other color options, in case you need them: -->
<meta data-controller="callout" data-callout-text-value="data-loader-url-value=&quot;/messages&quot;" data-callout-type-value="pink">

```html
<div data-controller="loader"
     data-loader-url-value="/messages">
</div>
```

<meta data-controller="callout" data-callout-text-value="data-loader-url-value=&quot;/messages&quot;" data-callout-type-value="blue">

```html
<div data-controller="loader"
     data-loader-url-value="/messages">
</div>
```

<meta data-controller="callout" data-callout-text-value="data-loader-url-value=&quot;/messages&quot;" data-callout-type-value="green">

```html
<div data-controller="loader"
     data-loader-url-value="/messages">
</div>
```
