# HTML

**TODO**: this chapter is a work in progress.

HTML stands for "Hyper Text Markup Language". It is not a programming language, but a markup language. What this means is that HTML adds structure to a text document, labeling the pieces of a document in a standardized way so the browser can interpret this visually. Fundamentally every HTML document is a hierarchical structure made up of elements and their content.

HTML uses tags to structure the document. You can think of tags as little labels between `<` angle `>` brackets. For instance, say you have a paragraph, you might mark that as such using the `<p>` tag. This signifies the start of a paragraph, the text after the `<p>` will be treated by your browser as a paragraph. You denote the end of the paragraph by inserting a closing tag. Most tags have a closing tag, they are the same as the open tag, but have a `/` slash before the tag name. `</p>` is the closing tag for a paragraph.

```html
<p>This is a paragraph.</p>
```

## Tags, Elements, Attributes

As you've seen the `<p>` is the **opening tag** for a paragraph and the `</p>` is the **closing tag**.

It is common to talk about elements. They make up the HTML document. When we talk about an **element**, we mean the whole thing between open and closing tags. So you can say that tags mark the beginning and end of an element.

Opening tags can have attributes. An **attribute** lets you specify additional data for a tag. Some tags require attributes to be set. The format is `key="value"`. A tag can have multiple attributes.

The most common attributes which you can put on every tag are:

* `id` Used to specify a unique identifier for a tag. Make sure your id's are unique. Example: `<h1 id="logo">App Academy</h1>`
* `class` Used to add classes which can group certain tags.
* `title` Used to show a little pop up when you hover over an element. Example: `<abbr title="Hypertext Transport Protocol">HTTP</abbr>`

Examples of other attributes that are specific to particular tags are:

* `href` Used for a link to point somewhere. Example: `<a href="http://www.appacademy.io/">App Academy</a>`
* `src` Used to specify the source for an image. Example: `<img src="happy_cat.gif">`

There are many more attributes you will encounter.


## Document structure

A correct HTML document should have the bare minimum of the following:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Page Title</title>
</head>
<body>
  ...
</body>
</html>
```

* The **doctype** `<!DOCTYPE html>` declares that this is an HTML document.
* The `<html>` element contains the whole document.
* The `<head>` element contains all meta data of the document. This includes the `<title>` of the page, as well as a `<meta>` tag declaring the character set used (utf-8).
* The `<body>` element contains all the content of the page.

## Tags you should know

Core elements

* **html** - holds the whole document, most senior element, always
* **head** - holds "meta" information about the document
* **body** - holds the actual content

Common head elements

* **meta** - used for various document "meta" information
* **title** - page title
* **link** - refers to other documents, most commonly the stylesheet
* **script** - holds inline JavaScript or refers to a .js file
* **style** - holds inline CSS

Generic elements (only used when no better semantic element can be found)

* **div** - block group of some content
* **span** - inline group of some content

**img** - used to embed an image in the document

Text structure elements

* **h1, h2, h3, h4** - used for headings
* **p** - used for paragraphs
* **blockquote** - user for quotes
* **pre** - used for poems, code and other content that requires preservation of white space formatting.
* **hr** - creates a line
* **strong** - shows strong emphasis by making text bold
* **em** - shows emphasis by making text italic
* **a** - creates a link

List elements

* **ul** - unordered list, may only contain list items as direct children.
* **ol** - ordered list, may only contain list items as direct children.
* **li** - list item

Table elements

* **table** - table
* **tr** - table row
* **td** - table cell

Form elements

* **form**
* **label**
* **input**
* **button**
* **select**
* **option**
* **textarea**


### New HTML 5 tags

You may use these instead of generic `<div>` tags to add more semantic meaning to your document.

* section
* article
* header
* footer
* figure


