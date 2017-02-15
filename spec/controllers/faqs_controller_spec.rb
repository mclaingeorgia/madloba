require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe User::FaqsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Faq. As you add validations to Faq, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      question: "What is Rehab GE?",
      answer: "Rehab GE is a free online database that allows you to search for rehabilitative services in and around your community, city or region throughout the country of Georgia. The home page is a map, which uses markers to show the exact location of the services you are searching for.  "
    }
    # skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    { question: nil }
    # skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FaqsController. Be sure to keep this updated too.
  # let(:valid_session) { {} }

  # describe "GET index" do
  #   it "assigns all faqs as @faqs" do
  #     faq = Faq.create! valid_attributes
  #     get :index#, {}, valid_session
  #     expect(assigns(:faqs)).to eq([faq])
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested faq as @faq" do
  #     faq = Faq.create! valid_attributes
  #     get :show, {:id => faq.to_param}#, valid_session
  #     expect(assigns(:faq)).to eq(faq)
  #   end
  # end

  # describe "GET new" do
  #   it "assigns a new faq as @faq" do
  #     get :new, {}#, valid_session
  #     expect(assigns(:faq)).to be_a_new(Faq)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested faq as @faq" do
  #     faq = Faq.create! valid_attributes
  #     get :edit, {:id => faq.to_param}#, valid_session
  #     expect(assigns(:faq)).to eq(faq)
  #   end
  # end

  describe "POST create" do
    context "with valid params" do
      before do
        @faq = Faq.create(valid_attributes)
      end
      # it "creates a new Faq" do
      #   expect {
      #     post :create, {:faq => valid_attributes}#, valid_session
      #   }.to change(Faq, :count).by(1)
      # end

      # it "assigns a newly created faq as @faq" do
      #   post :create, {:faq => valid_attributes}#, valid_session
      #   expect(assigns(:faq)).to be_a(Faq)
      #   expect(assigns(:faq)).to be_persisted
      # end

      it "redirects to the created faq" do
        #post :create, { :faq => valid_attributes }#, valid_session
        post :create, faq: @faq
        expect(response).to redirect_to(Faq.last)
      end


      # it 'creates a new category' do
      #   expect{
      #     post :create, category: @category
      #   }.to change(Category,:count).by(1)
      # end

      # it 'redirects to the new category' do
      #   post :create, category: @category
      #   expect(response).to redirect_to :action => :edit, :id => assigns(:category).id
      # end

    end

    # describe "with invalid params" do
    #   it "assigns a newly created but unsaved faq as @faq" do
    #     post :create, {:faq => invalid_attributes}#, valid_session
    #     expect(assigns(:faq)).to be_a_new(Faq)
    #   end

    #   it "re-renders the 'new' template" do
    #     post :create, {:faq => invalid_attributes}#, valid_session
    #     expect(response).to render_template("new")
    #   end
    # end
  end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested faq" do
  #       faq = Faq.create! valid_attributes
  #       put :update, {:id => faq.to_param, :faq => new_attributes}#, valid_session
  #       faq.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested faq as @faq" do
  #       faq = Faq.create! valid_attributes
  #       put :update, {:id => faq.to_param, :faq => valid_attributes}#, valid_session
  #       expect(assigns(:faq)).to eq(faq)
  #     end

  #     it "redirects to the faq" do
  #       faq = Faq.create! valid_attributes
  #       put :update, {:id => faq.to_param, :faq => valid_attributes}#, valid_session
  #       expect(response).to redirect_to(faq)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the faq as @faq" do
  #       faq = Faq.create! valid_attributes
  #       put :update, {:id => faq.to_param, :faq => invalid_attributes}#, valid_session
  #       expect(assigns(:faq)).to eq(faq)
  #     end

  #     it "re-renders the 'edit' template" do
  #       faq = Faq.create! valid_attributes
  #       put :update, {:id => faq.to_param, :faq => invalid_attributes}#, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested faq" do
  #     faq = Faq.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => faq.to_param}#, valid_session
  #     }.to change(Faq, :count).by(-1)
  #   end

  #   it "redirects to the faqs list" do
  #     faq = Faq.create! valid_attributes
  #     delete :destroy, {:id => faq.to_param}#, valid_session
  #     expect(response).to redirect_to(faqs_url)
  #   end
  # end

end
