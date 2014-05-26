Knowledge Forum
===============

1. Fork and clone this repo as per usual
2. Change into your project directory
3. Run bundle
4. Change the database.yml.example file to database.yml and update your postgres settings
5. Run ```rspec``` - should get failing tests!

TODO
====

* Finish the unit test post_spec.rb that simulate a data import. It needs to set the title and body given a string input collated from a number of Post models.
* The parser should output a file in your /tmp directory called posts.sql, containing a SQL string that will add your dummy models data to postgres.
* Refactor your parser to work with an input file, and bring in the data/small.xml file and make sure it brings in 48 articles into a file.
* cat your output files into postgres using:
``` cat /tmp/posts-0.sql | psql postgres knowledge_forum_development```
* Try to get it to work with the large XML file. It should bring in 153081 results.
* Visit https://archive.org/details/stackexchange and bring in more xml files, prizes for the most articles imported.

Tips
====

* After you've got your unit tests running, run the sample parser with

  ruby lib/post_parser.rb data/small.xml
