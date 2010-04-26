PaperclipGd2Processor
=====================

A processor for paperclip. It uses GD2.

Example
-------

    has_attached_file :photo,
      :styles => {:medium => '400x400', :thumb => '20x20#'},
      :processors => [:gd2_thumbnail]

Requirements
-------

* paperclip
* gd2

Copyright (c) 2009 jugyo, released under the MIT license
