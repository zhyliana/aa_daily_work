# Bootstrap

* Intro/Examples/Documentation on Bootstrap website
* Add `gem 'bootstrap-sass'` to Gemfile
* Rename `application.css` to `application.css.scss`
* Add `@import "bootstrap";` to `application.css.scss`
* Add `//= require bootstrap` to `application.js`
* Set up SimpleForm
  * Add `gem 'simple_form'` to Gemfile
  * Install config: `rails generate simple_form:install --bootstrap`
* Set up `application.html.erb` in layouts
* Think about the elements your application needs
* Grid layout `.container`
* Navbar `.navbar`
* Forms / SimpleForm
  * Instead of form_for use simple_form `<%= simple_form_for(@object, html: {class: "form-horizontal"}) do |f| %>`
  * Inline label checkboxes `<%= f.input :attribute_name, label: false, inline_label: true %>`
* Flash messages / Alerts `.alert`
* Pagination with Kaminari
  * Add `gem 'kaminari'` to Gemfile
  * Generate a config file `rails g kaminari:config`
  * Generate the bootstrap pagination `rails g kaminari:views bootstrap`
* Thumbnails `.thumbnails`
* Media objects `.media`
* Typography
  * Page header `.page-header`
  * Lines `<hr>`
* Buttons `.btn`
* Tables `.table`
* Icons `<i class="icon-..."></i>`
* Tooltips
  * Requires minor js setup `$("[rel~='tooltip']").tooltip();`
* Useful to make helpers for bootstrap html snippets
  * Page title
  * Icons

You may find a lack of spacing between your Bootstrap elements on the page. To set the vertical margins of elements in your application.css, you may do something like this:

```css
header, footer, .media, table {
  margin: 30px 0;
}
```
Finally, you should customize your Bootstrap styles, using  different fonts, colors and sizes. Customizing the look of your app is a good idea if it is facing the public.
