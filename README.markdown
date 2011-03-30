Calling Anobii API with Ruby
============

Setup
------------
* apply your Anobii API key at http://www.anobii.com/api
* update the API_KEY and API_SECRET_CODE value in the file

Functions Supported
------------
* get top ten books in your bookshelf (anobii.shelf.getSimpleShelf)
* get book details, such as title, subtitle, format, language and book cover image url (anobii.item.getInfo)

Note
------------
Instead of directly using the book cover image the server gave, I manipulated the url to retrieve a higher resolution.

Future Enhancement
------------
* add paging support for SimpleShelf
* add filter by progress for SimpleShelf
* add sample implementation with CSS, jQuery AJAX and Pagination
