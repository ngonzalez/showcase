```
 _______                     __                     
|   _   |.-----.-----.-----.|  |--.---.-.----.-----.
|       ||  _  |  _  |__ --||     |  _  |   _|  -__|
|___|___||   __|   __|_____||__|__|___._|__| |_____|
         |__|  |__|   
```
# Showcase Web Site
Public showcase web site for Appshare services

<a id="rails"></a>
## [# Ruby on Rails](#rails)

#### Install Ruby 3.4.9
```
% ruby --version
ruby 3.4.9 (2026-03-11 revision 76cca827ab) +PRISM [arm64-darwin23]
```

#### Run bundle install
```
bundle
```

#### Start puma
```bash
bin/puma -t 4:4 -b tcp://127.0.0.1:3000 ./config.ru
```

#### Run database migrations
```bash
bin/rails db:migrate
```

#### Precompile assets
```bash
bin/rails assets:precompile
```

#### Start sass
```bash
bin/rails tailwindcss:watch
```

<a id="daisyui"></a>
## [# Daisy UI](#daisyui)


#### Tailwind CSS Documentation

[https://v3.tailwindcss.com/docs/installation/](https://v3.tailwindcss.com/docs/installation/)

#### Install daisyUI for Rails

[https://daisyui.com/docs/install/rails/](https://daisyui.com/docs/install/rails/)

<pre>
Daisy UI is installed as Node dependency with the following commands:
</pre>

```
npm init -y
npm install daisyui@latest
```
