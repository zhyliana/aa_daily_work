# TodoApp

## Phase I: Project/Item

* A `Project` has many `Item`s todo.
* Write a form for `Project` and for `Item`s.
    * A `Project` should have a title and a text description of its purpose.
    * An `Item` should have a title, description, whether it was completed.
    * Select the `Project` from a select tag when you create a new item.
* The `Project` show page should list the `Item`s.
    * You don't know how to check the items as completed/uncompleted yet from
      the `Project` show page yet. Let the user click through to the
      `ItemsController#edit` page to do that. It's clunky, but stay the
      course.
* The `Item` show page should contain the `details` of the `Item`.
* Add links from the `Item` back to the `Project`.

## Phase II: Team/Project

* Each `Project` belongs to one `Team`.
* The `Team` show page should list the several `Project`s.
* Select the `Team` from a select tag.
* Add links from the `Project` back to the `Team`.

## Phase III: User

* A `User` may belong to many `Team`s; a `Team` will have many `User`s.
* You'll need a `TeamMembership` model.
* Use check boxes to associate `User` and `Team`.
* Your `User` show page should list the `Team`s the `User` is a member of.
* The `Team` show page should list the members.

## Phase IV: Nested routes

### Phase IVa: Nested `new` route

Suppose we want to add a new `Project` for a `Team`. We could go to the
`Project` form page, select the `Team` from the drop down, and then fill out
the form. However, if we're already on the `Team`'s show page, we would like
to simply click a link that will take us to the `Project` form, pre-selecting
the `Team` in the form.

One way to do this is to add a nested route:

```ruby
resources :teams do
  resources :projects, :only => [:new]
end
```

Requests to `teams/123/projects/new` will hit `ProjectsController#new`, but
with `params[:team_id]` set to `123`. Use this to create a `Project` with the
`team_id` attribute already set.

Your old `/projects/new` route should also still work (both routes will hit
the same controller action); it just won't do any default `Team` selection,
of course.

### Phase IVb: Nested `index` routes

Your `Project` show page lists all the `Item`s. This is fine, but if your
`Project` were to accumulate more data (maybe it has a long description, an
image, administrators, watchers, etc), you may not want to list all the
`Item`s on the show page.

To anticipate having more functionality in `Project`, we want to learn how to
break the associated `Item`s out to their own page:
`projects/:project_id/items`. This page can list the items in detail.

Nest an items resource within your projects resource. You only need the index
route. The `ItemsController#index` action should pull out the `project_id`
and only list the `Item`s for this `Project`.

The top-level items resource doesn't need an `index` method; it probably
doesn't make sense to list all the items for all the projects.

### Discussion: nested routes

It is typical to restrict nested routes to only `new` and `index` options.
The instance routes (the instance routes: `show`, `edit`, `update`, `delete`
are best accessed through the top-level resource). That's because it's more
convenient to `GET /items/123` than `GET /projects/456/items/123`; the
project id is redundant anyway if you have the item id.

As we've seen, `new` and `index` can be valuable nested routes; these are
collection methods, they don't include an item id.

You won't often need the `create` action (the last collection method) in your
nested resource. `POST /projects/456/items` is likely to be redundant, since
the project id will typically be embedded in the items parameters posted.

Finally, note that if you must create an item for a project, you may remove
the `new` and `index` resources. **Remove them from the top level items
resource**.

## Phase V: Checking projects as done in-line

Improve your `Project` show page so that you can check the items as
completed/uncompleted.

### Many ordinary forms

* Your `Project` show page iterates through the items, displaying a link to
  each one.
* For each link, show an `Item` form next to it. This form needs only to have
  a checkbox (completed or not) plus a submit button.

## One special form

This was a little annoying because we have a submit button for each `Item`.
We want checkboxes for each, but a single update button.

* Add an HTML `form` tag to your `Project` show page. Don't use `form_for`.
  This will be a special form, not a simple form for a single model object.
* Inside the `form`, iterate through the items one by one.
    * Display a link to the item show page.
    * Also, add a raw check box (`check_box_tag`); this will let the user
      toggle whether the item is completed.
    * Choose input names like `items[123][completed]` for `Item` #123.
    * Value should be "true".
    * Set the default value based on whether the item has already been
      completed.
* Add a submit button at the end
* Add a controller action, `ItemsController#batch_update`.
    * Iterate through the uploaded items, set the completed value as
      necessary.
* So far, **we can only set items as completed**; we can't uncomplete items.
    * The problem is that if a check box tag isn't selected, it doesn't get
      uploaded
    * To make sure that "false" will be uploaded if the checkbox isn't
      checked, add a hidden field, `items[123][completed]`, with value
      "false". Add this the line before the check box.
    * If the checkbox is checked, its value will "override" the hidden field;
      if not at least the hidden field's "false" value will be uploaded.
    * Note that this is kind of like the "bumper" checkbox.

## Bonus

Now that you know what the HTML should be, rewrite your forms with the Rails 
form helpers. You need to have equal facility with HTML and Rails forms helpers. 
Use the Rails Guides and API and view the source for the page to make sure the form
helpers generate the HTML you expect.
