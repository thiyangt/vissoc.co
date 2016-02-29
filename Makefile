SSH_USER = kjhealy@kjhealy.co
DOCUMENT_ROOT = ~/public/vissoc.co/public_html
PUBLIC_DIR = public/
HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))


all: clean deploy

html: $(HTML_FILES)

%.html: %.Rmd
	R --slave -e "set.seed(100);rmarkdown::render('$<')"
	proc-panweb.sh $@

clean:
	$(RM) $(HTML_FILES)

public: html
	cp *.Rmd public/
	cp *.html public/
	cp styles.css public/
	cp -r libs public/
	cp -r assets public/
	find public -type d -print0 | xargs -0 chmod 755
	find public -type f -print0 | xargs -0 chmod 644

deploy: public
	rsync -crzve 'ssh -p 22' $(PUBLIC_DIR) $(SSH_USER):$(DOCUMENT_ROOT)

.PHONY: clean
