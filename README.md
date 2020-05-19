# Course Material for PM566

The course website is based off the [course template](https://github.com/kjhealy/course_template) by [Kieran Healy](https://kieranhealy.org/).

The PM566 course webpage is linked at the top of this page.

This skeleton uses the [Academic Hugo theme](https://sourcethemes.com/academic/), with some slight template modifications found in `/assets/` 
and `layouts/`. The theme is included as a submodule, so when when cloning for the first time, use this command to get the theme too:

    git submodule update --init --recursive
    
Then you can use `blogdown::serve_site()` to render the website locally. Remember to run `blogdown::serve_site()` before pushing new changes.

# Adding material

To add material for week X you need to do the following.

## Readings page

Create a file named `0X-reading.Rmd` in the `content/reading/` folder. You can use the following as a starting point:

```
---
title: "Add a title here"
date: "2018-09-04"
citeproc: false
bibliography: ../../static/bib/references.bib
csl: ../../static/bib/chicago-fullnote-bibliography-no-bib.csl
---

# Required reading

# Optional reading

```

This page follows general rmarkdown syntax. You don't need to knit this file as it automatically is knitted each time the website is rendered. Refrain for having long running code in this document. Once you are done with this file, modify `data/schedule.yaml` by adding `reading: "0X-reading"` as the appropriate week.

## Class page

Create a file named `0X-class.Rmd` in the `content/reading/` folder. You can use the following as a starting point:

```
---
title: "Add a title here"
linktitle: "X: short title"
date: "2020-01-10"
class_date: "2020-01-10"
citeproc: false
bibliography: ../../static/bib/references.bib
csl: ../../static/bib/chicago-syllabus-no-bib.csl
output:
  blogdown::html_page:
    template: ../../pandoc/toc-title_html.template
    toc: false
menu:
  class:
    parent: Class sessions
    weight: 1
type: docs
weight: 1
editor_options: 
  chunk_output_type: console
---

## Lab Exercise


## Slides


## Links

```

The only thing in the yaml chunck you need to modify is the `title` and `linktitle` tags. Try to keep the linktitle to a couple of words.

You can link to pages in in the content folder by using syntax

```
[link](/assignment/0X-code)
```

to link to your slides follow the folder structure you used to save your slides to.

```
[link](/slides/01-welcome/slides.html)
```

## Assignments page

The assignment folder is where we keep all lab exersice, assignment and exam pages.

Create a fil in the `content/assignment/` folder. Prefix it with the week 0X, and append it with something meaningful. `0X-lab.Rmd` for lab exercises, `0X-project.Rmd` for projects etc.

The file will be knitted when the website is rendered.

If you want a specific (only one) assignment page to appear on the schedule page you need to modify `data/schedule.yaml` by adding `assignment: "0X-proejct"` as the appropriate week.

If you want to refer to an assignment from another page you can write 

```
[link](/assignment/name-of-file)
```
in your code.

## Slides

To add slides create a folder in the `static/slides` folder with the `0X-something`. Inside that folder you can put your slides as a .html, .pdf or whatever other appropiate file format.

The rmarkdown files in here will NOT be knitted when the website is rendered.

To link to your slides you simply the filepath relative to the `static/` folder. So the `slides.html` file in the `0X-hello/` folder can be linked to by writing

```
[link](/slides/0X-hello/slides.html)
```

