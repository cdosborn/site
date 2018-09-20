SHELL := /bin/bash
COPY_PREREQS := images/about.jpg site.css
BLOG_POSTS := $(basename $(wildcard posts/*))
BLOG_POST_TARGETS := $(addsuffix .html, $(addprefix dist/, $(BLOG_POSTS)))
COPY_TARGETS := $(addprefix dist/,$(COPY_PREREQS))

all: dist/index.html dist/about.html dist/index.rss $(BLOG_POST_TARGETS) $(COPY_TARGETS)

$(COPY_TARGETS): dist/%: $(COPY_PREREQS)
	@echo Copying from $* to $@
	@mkdir -p $(@D)
	@cp $* $@

dist/posts/%.html: posts/%/* fragments/* functions
	@mkdir -p $(@D)
	@{ cd posts/$*; \
	   . variables; \
	   if [ -z "$$public" -o "$$public" != "false"  ]; then \
	       ./index.sh > ../../$@; \
	   fi; \
	}

dist/index.html: index.sh posts/*/variables fragments/* functions
	@mkdir -p $(@D)
	{ for vars_file in $(filter posts/%, $^); do \
	    . functions; \
	    ( \
	      . $$vars_file; \
	      if [ -n "$$public" -a "$$public" = "false"  ]; then continue; fi; \
	      echo "./posts/$$(slugify "$$title").html $${date} $${title}"; \
	     ) \
	  done } | \
	./index.sh > $@

dist/index.rss: posts/*/variables rss.sh variables functions
	@mkdir -p $(@D)
	./rss.sh | \
	xmllint --format - > $@

dist/about.html: about.sh site.css images/about.jpg variables fragments/* functions
	@mkdir -p $(@D)
	./about.sh > $@

clean:
	@echo Cleaning up contents of dist folder
	@find dist -mindepth 1 -delete
