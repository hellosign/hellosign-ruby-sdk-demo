HelloSign Ruby Demo App
=======================

Introduction
------------

This is a demo application showing you how to use the [hellosign-ruby]() gem in an application.
This demo has 4 use cases, three on embedded and one on OAuth

How to setup this demo
----------------

####Obtain an Api key
Sign up for an API plan [here](https://www.hellosign.com/api/pricing). Adding embedded signing to your website requires a Silver or Gold API plan.
However, you can test the functionality for free by creating signature requests in test mode.
####Obtain a Client ID.
Sign up for a Client ID for your application [here](https://www.hellosign.com/oauth/createAppForm).

**Noticed**: The OAuth callback url must be **your-demo-app-domain/oauth** to work with this demo.
####Set the API key and Client ID in the demo app
1.Clone the app

```bash
git clone https://github.com/HelloFax/hellosign-ruby-sdk-demo
cd hellosign_ruby_demo
bundle install
```

2.Set your api key and client id
Open config/initializers/hello_sign.rb, set your keys

```ruby
HelloSign.configure do |config|
  config.api_key = 'api_key'
  # You can use email_address and password instead of api_key. But api_key is recommended
  # If api_key, email_address and password all present, api_key will be used
  # config.email_address = 'email_address'
  # config.password = 'password'
  config.client_id = 'your_cliend_id'
  config.client_secret = 'your_cliend_secret'
end

# This is a  pdf link for this demo only. You don't need to set this in real application.
# You can change this to other pdf link to use it in embdded demo
PDF_FILE = ['https://bitcoin.org/bitcoin.pdf']

```

####Deploy the app
You can't run this demo with localhost:3000 so you must deploy the demo app on [Heroku](https://heroku.com) or your own server to use it.


Demo explaination
-----------------
Requirement: You must be have your app and setup config file for HelloSign

### Embedded Signing
In this example, you will be shown how to add an embedded signature request to your Rails app

1.Create the embedded signature request.
```ruby
request = HelloSign.create_embedded_signature_request(
  :title => title,
  :subject => subject,
  :message => message,
  :signers => [{
      :email_address => email_address,
      :name => name
    }
  ],
  :file_urls => ['http://example/test.pdf']
)
```
2.Create embedded for this signature request
```ruby
embedded = HelloSign.get_embedded_sign_url :signature_id => request.signatures[0]["signature_id"]
@embedded_url = embedded.sign_url
```
3.Include "embedded.js" in your html
```html
<script type="text/javascript" src="//s3.amazonaws.com/cdn.hellofax.com/js/embedded.js"></script>
```
4.Show embedded to client

```html
<script type="text/javascript">
    function openSigningDialog() {
        HelloSign.init("#{HelloSign.client_id}");
        HelloSign.open({
            url: "#{raw @embedded_url}"
        });
    }
</script>
```

### Embedded Requesting
Request signatures for documents directly from your website with HelloSign's embedded request capability.
Follow the steps below to add this feature to your Rails application.

Let assume you have a form to get all information from the user

1.Create the embedded signature request.
In your action method
```ruby
request = HelloSign.create_embedded_signature_request(
  :title => params[:title],
  :subject => params[:subject],
  :message => params[:message],
  :signers => [{
      :email_address => params[:sender_email_address],
      :name => params[:sender_name]
    }
  ],
  #We support ActionDispatch::Http::UploadedFile out of the box so you can pass params files to files option
  :files => params[:files]
)

```
2.Create embedded for this signature request
```ruby
embedded = HelloSign.get_embedded_sign_url :signature_id => request.signatures[0]["signature_id"]
@embedded_url = embedded.sign_url
```
3.Include "embedded.js" in your html
```html
<script type="text/javascript" src="//s3.amazonaws.com/cdn.hellofax.com/js/embedded.js"></script>
```
4.Show embedded to client

```html
<script type="text/javascript">
    function openSigningDialog() {
        HelloSign.init("#{HelloSign.client_id}");
        HelloSign.open({
            url: "#{raw @embedded_url}"
        });
    }
</script>
```

### Embedded Requesting
Request signatures for documents based on a HelloSign Template directly from your website.
Follow the steps below to add this feature to your Rails application.

1.Create a template.
Create a template on the HelloSign website [here](https://www.hellosign.com/home/createReusableDocs). Your templates will be retrieved for use in the demo when you load this page.

Let assume you have a form to get all information from the user

1.Create the embedded signature request from template.
In your action method
```ruby
request = HelloSign.create_embedded_signature_request_with_reusable_form(
  :reusable_form_id => params[:template_id],
  :title => params[:title],
  :subject => params[:subject],
  :message => params[:message],
  :signers => params[:signers],
  :ccs => params[:signers],
  :custom_fields => params[:custom_fields]
)
```
2.Create embedded for this signature request
```ruby
embedded = HelloSign.get_embedded_sign_url :signature_id => request.signatures[0]["signature_id"]
@embedded_url = embedded.sign_url
```
3.Include "embedded.js" in your html
```html
<script type="text/javascript" src="//s3.amazonaws.com/cdn.hellofax.com/js/embedded.js"></script>
```
4.Show embedded to client

```html
<script type="text/javascript">
    function openSigningDialog() {
        HelloSign.init("#{HelloSign.client_id}");
        HelloSign.open({
            url: "#{raw @embedded_url}"
        });
    }
</script>
```
