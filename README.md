HelloSign Ruby Demo App
=======================

Introduction
------------

This is a demo application showing you how to use the [hellosign-ruby-sdk]() gem in an application.
This demo has 4 use cases, three using embedded flows and one using OAuth

How to setup this demo
----------------

####Obtain an Api key
You can either purchase an API plan [here](https://www.hellosign.com/api/pricing) or simply sign up for a free account and start making
API calls in test-mode. For non test-mode, adding embedded signing to your website requires a Silver or Gold API plan,
####Obtain a Client ID and Secret.
Create an app [here](https://www.hellosign.com/oauth/createAppForm). If you want to demo the OAuth flow, make sure you enable OAuth for your new app by checking the appropriate boxes.
Also, OAuth uses a callback URL which, in order to work properly, should be ONE of the following:
 A) On a domain that you will override the DNS lookup for (see below)
 B) Accessible through a tunnel such as Ngrok (see below)
 C) Accessible on the public internet with
 D) If using a typical home NAT-configured router you can use your public IP address if port-forwarding is set up correctly.

**Notice**: This demo app also expects the OAuth callback url to be of the form **your-demo-app-domain/oauth** to work properly with the internal app routing.
####Set the API key and Client ID in the demo app
1.Clone the app

```bash
git clone https://github.com/HelloFax/hellosign-ruby-sdk-demo
cd hellosign-ruby-sdk-demo
bundle install
```

2. Copy the example config file and set your api key and client id

cp config/initializers/hello_sign.rb.example config/initializers/hello_sign.rb

Then set your keys in the new file you just created, it should look similar to the following:

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

####Deploy the app (optional)
If you wish to have a publicly accessible demo app you must deploy somewhere like [Heroku](https://heroku.com).

#### Start the server
rails server (or possibly 'bundle exec rails server')
With the server running navigate to the main page e.g. http://127.0.0.1:3000

#### Callback URL setup - Ngrok option

In order for the OAuth part of the app to run correctly, you need to register your HelloSign app with an OAuth callback url. If you have not deployed the app to a publicly accessible IP and/or you want to deploy the app on localhost, you may want to use Ngrok (https://ngrok.com) because `localhost` or `127.0.0.1` is not recognized as valid callback urls by HelloSign. Here's how:

1. Download Ngrok (https://ngrok.com/download) and extract the zip file you've just downloaded

2. Open Terminal, navigate to the folder you've just extracted Ngrok to, then run `./ngrok <port number>` where port number is the local port your web server is running on (for example, 3000 that rails BRICK defaults to).
When Ngrok starts, it registers a random url (such as http://6eb6eb98.ngrok.com) and then forwards all traffic that reaches this url (port 80 for http or 443 for https) to your local server on the port you specified. What you need to do is to update your HelloSign settings for your app with this random url, so that the callbacks could be routed to your localhost.


#### Callback URL setup - Modify hostfile option

If you don't want to use Ngrok, you can use this option instead.

1. Now change your local host configuration such that the demo app can be access via a custom domain name. For example on a linux machine Open /etc/hosts and add `127.0.0.1 my.api-demo.hellosign.com`. Visit http://my.api-demo.hellosign.com in your browser to make sure the demo app is now accessible. Then update the domain name on your HelloSign app to be my.api-demo.hellosign.com. This step is important to make the embedded signing/requesting demos work.

2. Also change the HelloSign app OAuth callback url to be http://my.api-demo.hellosign.com/oauth

Demo explanation
-----------------
Requirement: You must have your config file setup correctly with an API key, client ID, and client secret and the server running.

When viewing the main page you will see 4 links which will each run a different demo.

### Embedded Signing
In this example, you will be shown how to add an iframe-embedded signature request to your Rails app

### Embedded Requesting

Request signatures for documents directly from your website with HelloSign's embedded request capability.

### Embedded Requesting from a Template
Request signatures based on your pre-built HelloSign Templates. Before running this demo ensure you have at least one template setup in your
account on the HelloSign website. Your templates will be retrieved for use in the demo when you load this page.

### OAuth Demo
In this demo you can see the oauth flow as a user is first sent to the an oauth link on the live HelloSign website,
asked to grant access to the 3rd party app (that's you), and then redirect back to the callback URL with access granted
or denied according to the user's selection.