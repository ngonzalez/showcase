test:
	@echo "Running all tests"; RAILS_ENV=test; bundle exec rspec spec/controllers/*.rb spec/requests/*.rb spec/services/*.rb --format progress --format RspecJunitFormatter --out rspec.xml;
.PHONY: test
clean:
	@echo "Clean logs, caches, test files and reports"; rm -f log/*.log log/*.log.[0-9]*; rm -rf tmp/cache/* coverage rspec.xml
.PHONY: clean
