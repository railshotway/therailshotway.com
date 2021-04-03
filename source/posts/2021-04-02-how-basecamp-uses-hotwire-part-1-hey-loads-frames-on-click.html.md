---
title: 'How Basecamp Uses Hotwire, Part 1: HEY Loads Frames On-Click'
tags:
  - Hotwire
  - Basecamp
  - Hey
---

How Basecamp uses Hotwire: Load frames on click
I reverse engineer Hey so you don't have to
Dont even use rails

```ruby
class A < B; def self.create(object = User) object end end
class Zebra; def inspect; "X#{2 + self.object_id}" end end

module ABC::DEF
  include Comparable

  # @param test
  # @return [String] nothing
  def foo(test)
    Thread.new do |blockvar|
      ABC::DEF.reverse(:a_symbol, :'a symbol', :<=>, 'test' + test)
    end.join
  end

  def [](index) self[index] end
  def ==(other) other == self end
end

anIdentifier = an_identifier
Constant = 1
render action: :new

def update_item!
  return false if invalid?

  ActiveRecord::Base.transaction do
    case @superpower[:action].to_sym
    when :add
      @shopping_cart.items.create!(superpower_id: @superpower[:id])
    when :remove
      @shopping_cart.items.find_by!(superpower: @superpower[:id]).destroy!
    end
  end

  true
rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
  aggregate_errors(e)

  false
end
```

```html
<div data-controller="gallery">
  <button data-action="click->gallery#next">…</button>
</div>
```

```js
// controllers/gallery_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  next(event) {
    // …
  }
}
```

```html
<details data-controller="popup-menu bridge--menu popup-picker"
         data-action="toggle->popup-picker#cancelOnClose
                     toggle->popup-menu#update
                     focusin@window->popup-menu#closeOnFocusOutside
                     click@window->popup-menu#closeOnClickOutside
                     reset->popup-menu#closeAndRestoreFocus"
         data-popup-picker-filtering-class="popup-picker--filtering"
         data-popup-picker-adding-class="popup-picker--adding">
  <summary class="navbar__item navbar__logo navbar__logo--open
                  colorize-after-purple btn--focusable"
            data-controller="hotkey"
            data-action="click->bridge--menu#show
                         toggle->popup-menu#update"
            aria-haspopup="menu"
            aria-label="Go to"
            data-hotkey="h,Meta+j">
    <a data-turbo-frame="my_navigation"
        data-popup-menu-target="link"
        href="/my/navigation"
        hidden="">
        HEY
    </a>
  </summary>

  <turbo-frame id="my_navigation"
               target="_top"
               role="menu"
               class="popup-menu popup-menu--padded popup-menu--centered
                      popup-menu--tall navbar__menu navbar__menu--hey">
    <span class="u-for-screen-reader" role="menuitem" aria-disabled="true">
      Loading
    </span>
  </turbo-frame>
</details>
```

```javascript
// popup_menu_controller.js
import { addToTabOrder, cancel, delay, nextFrame, removeFromTabOrder, wrapAroundAccess } from "helpers"

export default class extends ApplicationController {
  static targets = [ "item", "link", "input" ]
  static values = { lockOnSelection: Boolean }

  initialize() {
    if (this.hasLinkTarget) this.linkTarget.hidden = true
    this.observeMutations(this.removeTabstops, { childList: true })
  }

  connect() {
    this.summaryElement?.setAttribute("aria-haspopup", "menu")
    this.update()
  }

  disconnect() {
    this.close()
  }

  // Actions

  async update() {
    if (!this.element.open) {
      return
    }

    if (this.hasLinkTarget) {
      this.linkTarget.click()
    }

    if (this.frameElement) {
      if (this.frameElement.disabled) {
        this.close()
        return
      }

      await this.frameElement.loaded
    }

    await Promise.all(loadFrameElementsWithin(this.element))
    this.summaryElement?.setAttribute("aria-expanded", this.element.open)
    this.focusInitial()
    this.removeTabstops()
  }

  navigate(event) {
    switch (event.key) {
      case "ArrowUp":
        if (this.element.open && isActive(this.summaryElement)) {
          this.summaryElement.click()
          cancel(event)
        } else {
          this.focusPrevious()
          cancel(event)
        }
        break
      case "ArrowLeft":
        if (isInput(event.target)) break
        cancel(event)
        this.focusPrevious()
        break
      case "ArrowDown":
        if (!this.element.open && isActive(this.summaryElement)) {
          this.summaryElement.click()
          cancel(event)
        } else {
          this.focusNext()
          cancel(event)
        }
        break
      case "ArrowRight":
        if (isInput(event.target)) break
        cancel(event)
        this.focusNext()
        break
      case "Escape":
        cancel(event)
        this.closeAndRestoreFocus()
        break
      case "Enter":
        if (!(this.activeItem || isActive(this.summaryElement))) this.activateInitial()
        break
      case "Control":
        cancel(event)
        if (this.hasInputTarget) { this.inputTarget.blur() }
        break
    }
  }

  closeOnClickOutside({ target }) {
    if (this.element.contains(target)) return
    if (this.forceMenuOpen) return

    this.close()
  }

  closeOnFocusOutside({ target }) {
    if (!this.element.open) return
    if (this.element.contains(target)) return
    if (target.matches("main")) return
    if (this.forceMenuOpen) return

    this.close()
  }

  closeAndRestoreFocus() {
    this.close()
    this.summaryElement.focus()
  }

  toggleSummaryTabstop() {
    const summary = this.element.querySelector("summary")

    this.element.open ? removeFromTabOrder(summary) : addToTabOrder(summary)
  }

  async willFocusByMouse() {
    this.focusingByMouse = true
    await delay()
    this.focusingByMouse = false
  }

  displayMenu() {
    if (this.focusingByMouse) return
    this.element.open = true
  }

  close() {
    this.element.open = false
  }

  // Private
  //

  removeTabstops() {
    this.itemTargets.forEach(target => target.setAttribute("tabindex", "-1"))
  }

  async activateInitial() {
    await this.focusInitial()
    await nextFrame()
    this.initialItem?.click()
  }

  async focusInitial() {
    await nextFrame()

    if (this.hasInputTarget) {
      this.focusExclusively(this.inputTarget)
    } else if (this.hasItems) {
      this.focusExclusively(this.initialItem)
    }
  }

  async focusPrevious() {
    await nextFrame()
    this.focusExclusively(this.getItemInDirection(-1))
  }

  async focusNext() {
    await nextFrame()
    this.focusExclusively(this.getItemInDirection(+1))
  }

  getItemInDirection(direction) {
    const index = this.items.indexOf(document.activeElement) + direction

    return wrapAroundAccess(this.items, index)
  }

  get forceMenuOpen() {
    return this.lockOnSelectionValue && (
      this.element.querySelector(":checked") ||
      this.element.contains(document.activeElement)
    )
  }

  focusExclusively(element) {
    if (element) {
      this.removeTabstops()
      element.removeAttribute("tabindex")
      element.focus()
    }
  }

  get items() {
    return this.itemTargets.filter(isVisible)
  }

  get hasItems() {
    return this.itemTargets.some(isVisible)
  }

  get activeItem() {
    return this.itemTargets.find(isActive)
  }

  get initialItem() {
    return this.items[0]
  }

  get summaryElement() {
    return this.element.querySelector("summary")
  }

  get frameElement() {
    const id = this.hasLinkTarget && this.linkTarget.getAttribute("data-turbo-frame")
    return id && document.getElementById(id)
  }
}

function loadFrameElementsWithin(element) {
  const frames = [ ...element.querySelectorAll("turbo-frame[src]:not([disabled])") ]

  return frames.map(frame => frame.loaded)
}

function isInput(element) {
  return element.tagName == "INPUT"
}

function isActive(element) {
  return element == document.activeElement
}

function isVisible(element) {
  return element.offsetParent != null
}
```

```javascript
// popup_picker_controller.js
import { cancel, isMobile, resetInput } from "helpers"

export default class extends ApplicationController {
  static targets = [ "input" ]
  static classes = [ "filtering", "adding" ]

  // Actions

  filtering({ target }) {
    this.classList.toggle(this.filteringClass, target.value)
  }

  adding({ target }) {
    this.classList.toggle(this.addingClass, target.value)
  }

  cancel() {
    this.reset()
    this.inputTarget.focus()
  }

  cancelOnClose() {
    if (!this.element.open && !isMobile) this.reset()
  }

  resetAndRestoreFocus(event) {
    const [ firstInput ] = this.inputTargets

    if (firstInput !== document.activeElement) {
      cancel(event)
      this.reset()
      firstInput.focus()
    }
  }

  // Private

  reset() {
    this.inputTargets.forEach(resetInput)
    this.classList.remove(this.filteringClass, this.addingClass)
  }
}
```
