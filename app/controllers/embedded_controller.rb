class EmbeddedController < ApplicationController
  def signing
  end

  def create_signing
    begin
      embedded_request = HelloSign.create_embedded_signature_request(
        :test_mode => 1,
        :title => 'NDA with Acme Co.',
        :subject => 'The NDA we talked about',
        :message => 'Please sign this NDA and then we can discuss more. Let me know if you have any questions.',
        :signers => [{
            :email_address => params[:email],
            :name => params[:name]
          }
        ],
        :file_urls => PDF_FILE
      )

      signature_id = embedded_request.signatures[0].signature_id

      embedded = HelloSign.get_embedded_sign_url :signature_id => signature_id
      @sign_url = embedded.sign_url
      render 'signing'
    rescue => e
      render :text => e
    end
  end

  def requesting
  end

  def create_requesting
    begin
      data = {
        :test_mode => 1,
        :type => "request_signature",
        :subject => "Embedded Signature Request",
        :requester_email_address => "testuser@example.com",
        :message => "This is the message that goes along with your request."
      }

      if params[:requester_email_address]
        data[:requester_email_address] = params[:requester_email_address]
      end

      data[:files] = params[:files]

      resp = HelloSign.create_embedded_unclaimed_draft data
      claim_url = resp.claim_url;

      @sign_url = claim_url
      render 'requesting'
    rescue => e
      render :text => e
    end
  end

  def template_requesting
    @templates = HelloSign.get_templates(:page => 1)
    @data = (@templates.map {|t| t.data }).to_json
  end

  def create_template_requesting
    signers = []
    params[:signers].each_with_index do |signer, index|
      signer[1][:role] = signer[0]
      signers << signer[1]
    end
    ccs = []
    params[:ccs].each_with_index do |cc, index|
      cc[1][:role] = cc[0]
      ccs << cc[1]
    end
    begin
      request = HelloSign.create_embedded_signature_request_with_reusable_form(
        :test_mode => 1,
        :reusable_form_id => params[:template],
        :title => 'Purchase Order',
        :subject => 'Purchase Order',
        :message => 'Glad we could come to an agreement.',
        :signers => signers,
        :ccs => ccs,
        :custom_fields => params[:custom_fields]
      )
      signature_id = request.signatures[0].signature_id

      embedded = HelloSign.get_embedded_sign_url :signature_id => signature_id
      @sign_url = embedded.sign_url
      render 'template_requesting'
    rescue => e
      render :text => e
    end
  end

  def oauth_demo
  end

  def create_oauth_demo
    begin
      if cookies[:access_token]
        client = HelloSign::Client.new :auth_token => cookies[:access_token]
      else
        raise 'do not have auth token yet'
      end
      #make sure it not use config account
      client.email_address = nil
      client.password = nil

      request = client.send_signature_request(
        :test_mode => 1,
        :title => 'NDA with Acme Co.',
        :subject => 'The NDA we talked about',
        :message => 'Please sign this NDA and then we can discuss more. Let me know if you have any questions.',
        :signers => [{
            :email_address => params[:email],
            :name => params[:name],
          }
        ],
        :file_urls => PDF_FILE
      )
      flash[:notice] = "Sent Signature Request to #{params[:email]} successful"
      render 'oauth_demo'
    rescue => e
      render :text => e
    end
  end
end
