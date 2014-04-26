# WebStore

* Write a `User` model.
    * `User` should have `email` and `password` attributes.
* Write a custom login form.
    * When logged in successfully, set a cookie on the user.
    * Flash "logged in" on login.
* Write a logout form.
* Probably the best way to do this is to create a singular `resource
  :session`.
    * Hartl uses `get '/login'...`, but you should be comfortable using a
      resource for this.
    * **Do not copy Hartl**; you need to understand how this works.
* Write a `products/index` page.
* Let user add items to his cart.
    * Create a `resource :cart`.
    * The `update` action should be PUT a payload where (a) the keys are item
      ids and (b) the value is the number of items to add (could be negative
      to remove).
    * The `destroy` action should remove all the items from the cart.
    * **Store cart contents in the cookies; you must not have a `carts`
      table**.
    * Ignore `new`, `edit`, `create`.
    * Keep the cookie small, add item ids to the cart.
* Use `flash` to display a message "product X added" on next page load.
* Don't let users add things to their cart unless signed in. Use a
  `before_filter`.
* On logout, strike both session token and cart contents.
    * If we didn't strike the contents, the next user would inherit the old
      user's cart contents. Privacy fail :-(
* At checkout, show a confirmation page.
    * Display the items in the cart, plus their total price.
    * You may want to do this in the `/cart` show action.
    * Have a button to submit a request to create an `Order`.
        * The `Order` model represents a submitted `Order`.
    * This should post to an `/orders` resource.
    * `Order` model should `have_many` products and `belong_to` a `User`.
    * Clear the cart after checkout, of course.
* After checkout, send user an email with a link to their order show page
