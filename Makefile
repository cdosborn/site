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

$(IMAGE_TARGETS): dist/images/%: $(IMAGES)
	@echo "Copying images (and resizing to max width of 1080) $?"
	@mkdir -p $(@D)
	for file in $?; do \
	  magick $$file -resize 1080 dist/$$file; \
	done

$(BLOG_POST_TARGETS): dist/%.html: $(wildcard posts/*/*)
	@mkdir -p $(@D)
	@{ cd $*; \
	   . variables; \
	   if [ -z "$$public" -o "$$public" = "true"  ]; then \
	       ./index.sh > ../../$@; \
	   fi; \
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
	      if [ -z "$$public" -o "$$public" = "true"  ]; then \
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
