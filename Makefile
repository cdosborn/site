.SECONDEXPANSION:
SHELL := /bin/bash
COPY_PREREQS := site.css
COPY_TARGETS := $(addprefix dist/,$(COPY_PREREQS))
BLOG_POSTS := $(basename $(wildcard posts/*))
BLOG_POST_TARGETS := $(addsuffix .html, $(addprefix dist/, $(BLOG_POSTS)))
IMAGES := $(wildcard images/*)
IMAGE_TARGETS := $(addprefix dist/, $(IMAGES))

all: dist/index.html dist/posts.html dist/about.html dist/rss.xml $(BLOG_POST_TARGETS) $(COPY_TARGETS) $(IMAGE_TARGETS)

$(COPY_TARGETS): dist/%: $(COPY_PREREQS)
	@echo Copying from $* to $@
	@mkdir -p $(@D)
	@cp $* $@

$(IMAGE_TARGETS): dist/%: %
	@mkdir -p $(@D)
	magick $? -resize 1080 $@

$(BLOG_POST_TARGETS): dist/posts/%.html: $$(wildcard posts/%/*) fragments/*
	@echo Generating $@
	@mkdir -p $(@D)
	@{ cd posts/$*; \
	   . variables; \
		 ./index.sh > ../../$@; \
	}

dist/index.html: index.sh posts/*/variables fragments/* functions
	@mkdir -p $(@D)
	./index.sh > $@

dist/posts.html: posts.sh posts/*/variables fragments/* functions
	@mkdir -p $(@D)
	@{ for post_dir in $(wildcard ./posts/*); do \
	    . functions; \
	    ( \
	      cd $$post_dir; \
	      . variables; \
	      if [ -z "$$indexed" -o "$$indexed" = "true"  ]; then \
		echo "$${post_dir}.html $${date} $${title}"; \
	      fi; \
	     ) \
	  done } | \
	./posts.sh > $@


dist/rss.xml: posts/*/variables rss.sh variables functions
	@mkdir -p $(@D)
	./rss.sh | \
	xmllint --format - > $@

dist/about.html: about.sh site.css images/about.jpg variables fragments/* functions
	@mkdir -p $(@D)
	./about.sh > $@

clean:
	@echo Cleaning up contents of dist folder
	@find dist -mindepth 1 -delete

test-deploy: all
	rsync -navh dist/ cdosborn.com:/var/www/cdosborn.com

deploy: all
	rsync -avh dist/ cdosborn.com:/var/www/cdosborn.com
