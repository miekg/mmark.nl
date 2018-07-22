all:
	hugo -d /var/www/mmark.nl

.PHONY: clean
clean:
	rm -rf /var/www/mmark.nl/*

.PHONY: test
test:
	hugo server

