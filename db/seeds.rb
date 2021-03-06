# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Settings table, set with default values.
# setting_list = [
#     %w(app_name Madloba),
#     ['description', ''],
#     ['summary', ''],
#     ['contact_email', ''],
#     ['link_one_label', ''],
#     ['link_one_url', ''],
#     ['link_two_label', ''],
#     ['link_two_url', ''],
#     ['link_three_label', ''],
#     ['link_three_url', ''],
#     ['link_four_label', ''],
#     ['link_four_url', ''],
#     ['link_five_label', ''],
#     ['link_five_url', ''],
#     ['link_six_label', ''],
#     ['link_six_url', ''],
#     %w(chosen_map osm),
#     ['map_box_api_key', ''],
#     ['mapquest_api_key', ''],
#     ['map_center_geocode', ''],
#     ['latitude', '0.0'],
#     ['latitude', '0.0'],
#     %w(zoom_level 2),
#     ['city', ''],
#     ['state', ''],
#     ['country', ''],
#     ['facebook', ''],
#     ['twitter', ''],
#     ['pinterest', ''],
#     %w(ad_max_expire 90),
#     %w(setup_step 1),
#     ['image_storage', ''],
#     ['chosen_language', 'en']
# ]

# setting_list.each do |setting|
#   Setting.create( :key => setting[0], :value => setting[1] )
# end

# Create a default category
# Category.create(name: 'Default', description: 'Default category.', icon: 'fa-circle', marker_color: 'green')
PageContent.destroy_all
  #{ # '<p>You can use Sheaghe to search for any type of rehab service in Georgia. We have a whole database of service providers on the website; each of them registered according to their location, category of service and the types of service they provide.</p> <p>Using the search tool on the home page of Sheaghe, you can search for registered services by name, region, exact address, or by using keywords that describe the service you are looking for. Alternatively, or for a broader search, you can browse the categories of service, all of which are listed on the right hand side of the home page.</p> <p>Once your search results appear on the map, simply click on the marker to learn more about that specific service. From here, you can also follow the link to the Service Provider’s profile page, which gives you more detailed information about the services they provide as well as how to find them. You can also message the service provider directly through Sheaghe by using the instant messaging feature at the bottom of the Service Provider’s Profile page.</p> <p>If you are a service provider and would like to know more about registering your services on Sheaghe, please see <a href="/en/faq#register-service">here</a></p>'
  #{ # en: "<div class='toggleable-list-prefix'><div class='header'>Frequently Asked Questions (FAQ)</div></div><ul class='toggleable-list'><li><a name='block-1'>1. What is Sheaghe?<span class='caret'></span></a><div class='toggleable-list-text'><p>Rehab GE is a free online database that allows you to search for rehab services in and around your community, city or region within the country of Georgia. The website is based on a map, which uses markers to show the exact location of the services you are searching for. For more information about how this works, see <a href=\"#block-2\">here</a></p></div></li><li><a name='block-2'>2. How does it work?<span class='caret'></span></a><div class='toggleable-list-text'><p>You can use Rehab GE to search for any type of rehab service in Georgia. We have a whole database of service providers on the website; each of them registered according to their location, category of service and the types of service they provide. Using the search tool on the home page of Rehab GE, you can search for registered services by name, region, exact address, or by using keywords that describe the service you are looking for. Alternatively, or for a broader search, you can browse the categories of service, all of which are listed on the right hand side of the home page. Once your search results appear on the map, simply click on the marker to learn more about that specific service. From here, you can also follow the link to the Service Provider’s profile page, which gives you more detailed information about the services they provide as well as how to find them. You can also message the service provider directly through Rehab GE by using the instant messaging feature at the bottom of the Service Provider’s Profile page.</p><p>If you are a service provider and would like to know more about registering your services on RehabGE, please see <a href=\"#block-9\">here</a></p></div></li><li><a name='block-3'>3. How do I use it?<span class='caret'></span></a><div class='toggleable-list-text'><p>Rehab GE helps you search for all types of rehabilitation services in the country of Georgia. The key features of the site include the map, the search tool and the list of Categories. From the home page, you can search for services registered on Rehab GE in one of two ways:</p><ul class='numbered'><li><p>1. Using the search tool at the top of the page; simply type in the region or a keyword related to the service you are looking for (or both!) and hit enter; OR</p></li><li><p>2. By directly clicking a category from the list of service categories listed on the right hand side of the screen</p></li></ul><p>The services you are looking for should appear on the map as a coloured marker. Click on the markers to find out more about the services and follow the links to the Service Provider’s profile page.</p><p>You can use Rehab GE on your computer, tablet or mobile device. For the moment, it’s only available online and with proper Internet connection, but we are working on making it accessible offline too!</p></div></li><li><a name='block-4'>4. How do I sign up?<span class='caret'></span></a><div class='toggleable-list-text'><p>You can sign up by clicking the \"Sign up or Sign in\" button on the top left hand side of the home page. From there you need to follow the instructions and fill out the form to create an account. It’s as easy as that!</p><p>Click <a href=\"sign_up\">here</a> if you want to be automatically redirected to the Sign Up page.</p></div></li><li><a name='block-5'>5. Why would I want to sign up?<span class='caret'></span></a><div class='toggleable-list-text'><p>Signing up gives you access to some additional features of Rehab GE that allow you to:</p><ul><li><p>Send instant messages to registered service providers</p></li><li><p>Save a list of Favorite services, so you don’t have to search for them every time</p></li><li><p>If you are a service provider you will be able to update and edit your service profile as well as register additional services on the site at any time</p></li></ul><p>By signing up we know that you are a human being! Every profile opened helps us get an idea of what you like and don’t like about Rehab GE so we can improve the site and services to better suit your needs.</p></div></li><li><a name='block-6'>6. Can anyone Sign up? What if I don’t live in Georgia?<span class='caret'></span></a><div class='toggleable-list-text'><p>Sure!</p><p>Rehab GE is completely free and open source. As long as you have an internet connection and a computer, tablet or mobile device, you are welcome to sign up – even if you don’t live in Georgia. If you live outside Georgia and would like to see a website like this in your own country or Region, see <a href=\"#todo\">here[TODO]</a> for more information.</p></div></li><li><a name='block-7'>7. I am a service provider, how can I get my service to show up on Rehab GE?<span class='caret'></span></a><div class='toggleable-list-text'><p>If you are a service provider and your service is not already registered on Rehab GE you will need to Sign up <a href=\"sign_up\">here</a> before you can register your service. Be sure to indicate that you are a service provider when you Sign up to receive further instructions about registering services.</p><p>If you are already signed up, simply press the Register Services button on the right hand side of the home page and follow the instructions on the Registration.</p><p>Be aware that we review every single registration to make sure they are accurate and real. This takes time, usually around two weeks, so please be patient! We will contact you to let you know if your registration is successful – that means people will be able to search for you on Rehab GE.</p></div></li><li><a name='block-8'>8. I am a service provider, what do I do if my service is already on Rehab GE?<span class='caret'></span></a><div class='toggleable-list-text'><p>Congratulations! This means your service was pre-registered on Rehab GE, making it more accessible to a greater number of Georgians searching for rehabilitation services.</p><p>As a pre-registered service provider, you would have been contacted by the Rehab GE team and given written and / or verbal consent to having your service registered on the site. To complete the full validation of your service, you will need to <a href=\"sign_up\">Sign Up</a> and open an account. Once your account is activated, you can link the service to your personal account by clicking the link on the service information page. Activating the account will enable you to edit and update your personal profile as well as the information about your service. It will also turn on the instant messaging function, so that other registered users will be able to get in touch with you directly through the website.</p><p>If you would like to be automatically re-directed to the Sign Up page, please click <a href=\"sign_up\">here</a>. If you still need more information or are not sure why your service is registered on Rehab GE, please <a href=\"#todo\">Contact Us[TODO]</a>.</p></div></li><li><a name='block-9'>9. I am trying to register my services, but the button on the home screen is not working. What do I do now?<span class='caret'></span></a><div class='toggleable-list-text'><p>The register services function is only available to registered users.</p><p>You will need to <a href=\"sign_up\">Sign Up</a> and open an account with us before you can register your service. If you are already registered, make sure you are signed in, and then try the Register Services button again from the home page. If the button is still not working or the links appear to be broken, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know what’s going on. Unfortunately, things go wrong from time to time – we apologize for any inconvenience and will do our best to fix the problem as soon as possible!</p></div></li><li><a name='block-10'>10. I am trying to message a service provider, but the message box is not working<span class='caret'></span></a><div class='toggleable-list-text'><p>The Instant messaging feature is only available to registered users.</p><p>You will need to <a href=\"sign_up\">Sign Up</a> and open an account with us before you can message service providers through the website. If you are already registered, make sure you are signed in, and then try sending your message again.</p><p>For some services, the message box will be blocked indefinitely. This means the service provider has not validated their account yet or that they prefer to have users contact them by phone or an alternate email. Sometimes it is because they simply do not have an email address. In these cases, you can try calling the provider or visiting them in person. If you are still unsure, you can <a href=\"#todo\">Contact Us[TODO]</a> to check if they are validated or not.</p></div></li><li><a name='block-11'>11. What do you mean by “validated” service? How is it different from an “un-validated” service?<span class='caret'></span></a><div class='toggleable-list-text'><p>A “validated” service is one that has been reviewed by Rehab GE and is linked to a registered user on the site. Because they are linked to a user profile, this means you can message the service provider directly through the website using the Instant message box on the service provider’s information page.</p><p>An “un-validated” service has also been reviewed by Rehab GE to make sure it is real before being added to the database, but the service provider does not have a profile on Rehab GE. This means you cannot message them instantly through the website, but you can still get in touch by calling the phone number or visiting them in person. In some cases, a different email address may be provided on the service provider page so you can try sending an email the traditional way.</p></div></li><li><a name='block-12'>12. I want to Sign Up, but what if I don’t want to give my address or contact details?<span class='caret'></span></a><div class='toggleable-list-text'><p>No problem!</p><p>Just leave these sections empty when you are filling out the profile page. You will still need to provide a working email address in order to sign up, but this is so we can make sure you are a real person using the website. We will not use your email address to send spam or any other promotional information, ever. Please read our <a href=\"privacy_policy\">Privacy Policy</a> if you want to know more about it.</p><p>If you are a service provider, you are also free to leave the contact details empty, but remember that the more contact information you provide, the easier it will be for people to find you. We understand that you may not want people to email your personal account, which is why we recommend using a company email address, or opening a new email account that you can use on Rehab GE.</p></div></li><li><a name='block-13'>13. There are so many services listed! How do you make sure they are really providing what they claim?<span class='caret'></span></a><div class='toggleable-list-text'><p>All services and service providers are reviewed by the Rehab GE team before you are able to search for them on the website. This means we have called, visited or checked the service through someone else to make sure they are real and actively providing the services they say they are. Making sure the information stays accurate and up to date is a little bit trickier, but we have a system in place to make sure the service providers are active in updating their information page on a regular basis.</p><p>If you see a service provider on Rehab GE that you think is giving the wrong information about their services or is no longer operational, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know all about it. We will personally follow up every claim.</p></div></li><li><a name='block-14'>14. OK, I’ve found the service I need! How can I be sure it is still available?<span class='caret'></span></a><div class='toggleable-list-text'><p>The best way to make sure is to contact them! You can do this by calling them, sending them an email or sending an instant message through the website. If it is convenient for you, you can even go there in person.</p><p>As much as we try to make sure that all the services registered on Rehab GE are still functioning and up to date, we acknowledge that some might still slip through the cracks. We also cannot guarantee the quality of the services they provide. If you see a service provider on Rehab GE that you think is giving the wrong information about their services or is no longer operational, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know all about it. We will personally follow up every claim.</p></div></li><li><a name='block-15'>15. I sent an Instant message to the service provider. It’s been a long time and I still have no reply from them. What can I do?<span class='caret'></span></a><div class='toggleable-list-text'><p>Unfortunately there’s not a whole lot you can do. The instant message is sent to an email account, so it might be that the service provider is away or unable to reply at this time. Some service providers offer a different email address and telephone number on their information page. If you haven’t already, we suggest you give them a try.  If there is still no response, or you have a feeling that the service is no longer operational, please let us know <a href=\"#todo\">here[TODO]</a>.</p></div></li><li><a name='block-16'>16. What are all the colored markers with icons?<span class='caret'></span></a><div class='toggleable-list-text'><p>The colored markers indicate the category of service that is associated with the registered services. You will notice that some service providers are linked to more than one category – this is so that they are easier to search for. The colors themselves have no particular meaning, but the symbols do relate to the category in some way so that they are easily recognizable.</p><p>If you have any feedback or questions about the markers or the colors we have chosen, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know what you think.</p></div></li><li><a name='block-17'>17. What do the circles with numbers mean on the map?<span class='caret'></span></a><div class='toggleable-list-text'><p>These are the number of services related to your search category that are available in a single location. We have condensed them to make it more visually appealing. Click on the number to zoom in and find out more about the services available in that location.</p></div></li><li><a name='block-18'>18. Is this website only for Georgia? Is it available in any other countries?<span class='caret'></span></a><div class='toggleable-list-text'><p>At the moment, Rehab GE is focused on rehabilitation services available only in the country of Georgia. This is reflected in the map on our home screen. Other countries might have similar websites, offering similar services, but we have no association with them.</p></div></li><li><a name='block-19'>19. Is it only in Georgian and English?<span class='caret'></span></a><div class='toggleable-list-text'><p>Yes, at this time the only languages are Georgian and English</p></div></li><li><a name='block-20'>20. Is Rehab GE only available Online? What if I need to use it and I don’t have an internet connection?<span class='caret'></span></a><div class='toggleable-list-text'><p>Yes, at the moment Rehab GE is only available online, but we are working to fix that!</p><p>You can use it on your mobile device if you have access to data; however the site might work a bit slower than usual.</p></div></li><li><a name='block-21'>21. Is there a Rehab GE app?<span class='caret'></span></a><div class='toggleable-list-text'><p>Unfortunately there is no app, yet – we are working on it!</p></div></li><li><a name='block-22'>22. I want to develop a website like this for my country / region! How do I do it?<span class='caret'></span></a><div class='toggleable-list-text'><p>Great!  You can find all the information you need to start your own version of Rehab GE on Github. Click <a href=\"#todo\">here[TODO]</a> to access the information. Feel free to <a href=\"#todo\">Contact Us[TODO]</a> for more information about developing your own version of this website.</p></div></li></ul>",
  #{ # ka: "<div class='toggleable-list-prefix'><div class='header'>Privacy Policy</div><p>At Rehab GE, we are committed to protecting your privacy. Only those authorized as Administrators of the website are able to view and use information relating to all users – registered and unregistered – on the website.</p></div><ul class='toggleable-list'><li><a name='block-1'>Data Collection and information Use<span class='caret'></span></a><div class='toggleable-list-text'><ul><li><p>Rehab GE collects information and data about service users and Service providers that have Services Registered with the Rehab GE database.</p></li><li><p>All data and information that is collected through Rehab GE will be reviewed carefully by the administrators and remain confidential. The ultimate purpose of collecting any data and information about services and service users on this site will be to Improve the services offered through Rehab GE and to Identify the needs in regards to rehabilitative services throughout the country of Georgia.</p></li><li><p>Any other data collected on the site is purely for the purpose of running the site and will not be shared, rented or sold.</p></li><li><p>Rehab GE will not rent, sell, or share information about you with other people or non-affiliated companies or organizations.</p></li></ul></div></li><li><a name='block-2'>Contact and Instant Messaging service<span class='caret'></span></a><div class='toggleable-list-text'><ul><li><p>We reserve the right to send Service providers, that have rehabilitative services Registered on the website, certain communications relating to Rehab GE such as service announcements, administrative messages relating to their registration and Information page and any other messages that are considered essential to the functioning of the Rehab GE website without offering you the opportunity to opt out of receiving them</p></li><li><p>Instant messages sent through the site are one-off events. We will not distribute any email addresses to any third party or associated organization(s) of Rehab GE or use them for anything other than their intended purpose. See <a href=\"terms_of_use\">Terms of Use</a> for more information about the purpose of the site and Instant messaging system for Registered Users.</p></li><li><p>Any messages sent through the Instant messaging feature on Rehab GE are delivered directly to the inbox of the email specified by the Service provider. Rehab GE will not be able to view or edit the Instant messages before the Service Provider receives them. Rehab GE will therefore take no responsibility In the case that any offensive of inappropriate content is sent and received by the Service Provider through this instant messaging service. In such cases, it is the responsibility of the Service provider to contact the Rehab GE team of the breach of Terms of use. In such cases Rehab GE will take whatever action possible to attempt to rectify the situation.</p></li><li><p>Once received, Service Providers are responsible for responding to the Instant Messages from Service Users within a reasonable timeframe and in an acceptable manner which is in accordance with the Terms of Use of this website and Privacy Policy. In the case that a Service User has received an offensive email or any inappropriate content from the Service Provider they are responsible for immediately notifying the Rehab GE Administrators of the situation.</p></li></ul></div></li><li><a name='block-3'>Confidentiality and Security<span class='caret'></span></a><div class='toggleable-list-text'><p>At Rehab GE we limit access to personal information about you to authorized administrators of the website who need to view this information in order to advise and assist in the development of services that will better serve the users and their needs.</p></div></li><li><a name='block-4'>Changes to this Privacy Policy<span class='caret'></span></a><div class='toggleable-list-text'><p>Rehab GE may update this policy from time to time. We are not required to inform of any minor changes, however if there is what we consider to be a significant change to the way in which we treat your personal information, we may inform you by sending an email to the email address that is associated with your Rehab GE account or by placing a prominent notice on our site</p></div></li><li><a name='block-5'>Copyright Complaints<span class='caret'></span></a><div class='toggleable-list-text'><p>Rehab GE respects copyright, and we prohibit users of our Services from submitting, uploading, posting, or otherwise transmitting any Content on the Services that violates another person’s proprietary rights.</p><p>To report anything that you believe may be an infringement of copyright laws, please inform the Administrative Team immediately via email. Contact information can be found on the <a href=\"#todo\">Contact Us[TODO]</a> page.</p></div></li><li><a name='block-6'>Termination<span class='caret'></span></a><div class='toggleable-list-text'><p>By Rehab GE: We reserve the right to modify, suspend, or terminate the operation of, or access to, all or any of the Services provided through this website at any time and for any reason. In addition your individual access to, and use of, the Services may be terminated at any time, for any reason by the Rehab GE Administrative Team. In the case that such an event does occur, we will contact you by email to your verified email address that is associated with your Personal Account.</p><p>By you: If you wish to terminate this agreement, you may immediately stop accessing or using the Services at any time. The procedure for closing your account is described in <a href=\"terms_of_use\">Terms of Use</a></p><p>Automatic upon breach: Your right to access and use the Services offered on Rehab GE terminates automatically upon your breach of any of the <a href=\"terms_of_use\">Terms of Use</a>.</p></div></li></ul>"
  #{ # en: "<div class='toggleable-list-prefix'><div class='header'>Terms of Use</div><p>This page tells you all about us and the legal terms and conditions related to the use of this website. Please read them carefully and make sure you understand all the information before using any of our. By choosing to use this online service, and by registering as a service provider on this site, you automatically agree to abide by the terms and conditions stated below.</p><p>It is advised for you to print a copy of this page for future reference.</p><p>Note that from time to time, we may need to change, remove or add to the Terms. Therefore you are advised to please check the Terms each time you wish to use this site to make sure you understand the terms that apply at the time.</p></div><ul class='toggleable-list'><li><a name='block-1'>1. Definitions<span class='caret'></span></a><div class='toggleable-list-text'><p>In these terms:</p><ul><li><p>“User” means any individual using the website to search for rehabilitation services. This includes both registered and unregistered users as well as Service Providers and Administrators</p></li><li><p>“Registered User” Any user that has signed up and established an account on Rehab GE. They will have access to additional features of the site including Instant messages to the Service provider through the website and ability to build a Favorites list.</p></li><li><p>“Services” or “Website Services” includes all functions and features that are available to Users on the Rehab GE website. This includes, but is not limited to search for services, User registration, Favorites feature and Instant messaging to services</p></li><li><p>“Registered Service” is any rehabilitation service that is searchable through the Rehab GE search function located on the home screen. Registered services have all been verified for accuracy of information and contact details prior to publishing.</p></li><li><p>“Service Provider” is any individual with a registered account that has a verified rehabilitation service that is searchable by other Rehab GE users. They also have their email address linked to the Instant messaging feature on the information page about their service. This allows other users to message them directly through the Rehab GE website. Service providers have additional responsibilities in ensuring the details of their services and email address remain accurate and up to date. Please see <a href=\"#todo\">Participating in our community – Registered Users[TODO]</a> for further information.</p></li><li><p>“Published” means that the service is searchable through the Rehab GE database</p></li><li><p>“Administrator” means user that has the authority to access additional features of Rehab GE as well as regulate information about services that is published on the site and is searchable by other users</p></li><li><p>“Content” is anything that can be uploaded to the site by users or administrators, including but not limited to, written information, instant messages, photographs, images, videos and links to other sites</p></li><li><p>“Instant message” is the message sent directly to the service provider using the message box on the Service provider information page</p></li></ul></div></li><li><a name='block-2'>2. Information about us<span class='caret'></span></a><div class='toggleable-list-text'><p>We are the McLain Association for Children (MAC), and are the organization responsible for establishing and operating this website. Together with the Ministry of Health, Georgia we are the main Administrators of this site. For any queries, you may find all the necessary contact information on our Contact Us page.</p></div></li><li><a name='block-3'>3. Participating in our Community – Registered Users<span class='caret'></span></a><div class='toggleable-list-text'><p>As a user of this website, you are responsible for:</p><ul><li><p>Making all the necessary arrangements for you to have access to the site</p></li><li><p>Opening and account and completing your profile using your own personal information at your own discretion (through the use of an alias or nickname if desired)</p></li><li><p>Provide personal information, with the understanding that it may be used in collecting data (by MAC, the MoH and any other partner organization authorized by the administration of this Website) with the aim of improving the availability and quality of rehabilitation services in the country of Georgia</p></li><li><p>Maintain the security of your passwords and identification</p></li><li><p>Be fully responsible for all the uses of your account</p></li></ul><p>In addition, as a Service Provider and with services registered on this website, you have indicated that you:</p><ul><li><p>By providing your email address and upon confirmation of your account, you automatically consent to receiving instant messages through the website. For more information about the Instant messaging feature, please see – 4. Instant Messaging Feature for Service providers.</p></li><li><p>You will update your personal information and email address as required, in order to maintain the accuracy of information provided on the site as well as the integrity of the instant messaging feature offered through your service profile</p></li><li><p>Agree to receive regular emails (at a minimum, every 6 months) to the email address specified in your profile requesting you to review and update the information about your services</p></li><li><p>Agree to allow all the updated information relating to your services to be reviewed and authorized by the administrators of this website before being published</p></li></ul><p>User accounts must not be set up on behalf of another Individual user, service provider or any other entity unless you have their prior consent and are authorized to do so. Please see the Privacy Policy for more information about Privacy and Confidentiality.</p></div></li><li><a name='block-4'>4. Instant Messaging Service for Service providers<span class='caret'></span></a><div class='toggleable-list-text'><p>This feature enables only Registered users to message the service provider through the message box on the Services profile page. Note that:</p><ul><li><p>Only Registered users are able to make use of the Instant messaging feature</p></li><li><p>The Instant message will be received only by the Service Provider and will not be viewed by any other third Party, including the administrators.</p></li><li><p>The message will be automatically directed to the inbox of the email provided by the Service provider. The Service provider is therefore responsible for ensuring their email address and contact details are correct and up to date at all times</p></li><li><p>Upon receiving the message, the Service Provider is required to respond appropriately to the user request.</p></li></ul><p>All Registered Users are expected to abide by these terms and Fair use when taking part in the Instant Messaging feature of this website. Inappropriate email exchanges from either service providers or registered service users will not be tolerated under any circumstances. In the case that inappropriate language or content is received by either user, they are responsible for informing the website administrator immediately. Contact details can be found here [link to Contact Us]</p></div></li><li><a name='block-5'>5. Closing of Accounts<span class='caret'></span></a><div class='toggleable-list-text'><p>The administrators of this website reserve the right to modify or discontinue your account at any time for any reason or no reason at all.</p><p>If you wish to close your account, you may do so by -???</p></div></li><li><a name='block-6'>6. Business deletion<span class='caret'></span></a><div class='toggleable-list-text'><p>We reserve the right to remove any Registered Services profiles if we feel that they're infringing on any laws or if they contain objectionable material such as adult content (including images, vulgar language, content or links). Please Read the section on Prohibited Conduct for further information on acceptable content and conduct on this Website.</p></div></li><li><a name='block-7'>7. How we use your personal information<span class='caret'></span></a><div class='toggleable-list-text'><p>All personal information you provide on this website is used in accordance with our <a href=\"privacy_policy\">Privacy Policy</a>. We make every possible attempt to keep your personal information safe, however you should be aware that this site, as well as any other site could potentially be a target for hackers. Please avoid posting any sensitive or private information that you would not want disclosed in the case of an unlikely security breach.</p><p>Rehab GE is a website that collects general data and statistics about the use of the website, with the aim of improving overall services offered through the website. We are committed to responsibly handling the information and data collected through our website and the website services. Please review the <a href=\"privacy_policy\">Privacy Policy</a> for more information about how data is collected and used from this website and services. Please take the time to read this as it does contain important terms that apply to you and all registered users of this site.</p><p>Please note that we will not sell, share or rent your personal information to any third party or use your email or mailing address for unsolicited mail. Any emails, messages or other information sent by us will only be in relation to the provision of agreed services on this website.</p></div></li><li><a name='block-8'>8. Fair use of our Site<span class='caret'></span></a><div class='toggleable-list-text'><p>We are not responsible for any damages caused by the use of this website, or by registering and advertising your rehabilitation services here. Please use our site at your own discretion and exercise good judgment as well as common sense when registering services and contacting service providers through the instant messaging function.</p><p>Access to the site is permitted on a temporary basis and we reserve the right to withdraw or amend the services and information we provide on our site without prior notice. We also reserve the right to alter the content of this site without communicating the alterations to the users, be they registered or unregistered. We will not be liable for any reason the site is unavailable at any time or for any period. Note that from time to time, we may restrict access to some parts of the site or block service profiles from being visible on the map. This applies to all users, including Registered Users and Services.</p><p>Please be aware that although we strive to include only accurate information about the rehabilitation services on our site, the material provided comes with no guarantees or warranties as to its accuracy.</p></div></li><li><a name='block-9'>9. Prohibited Conduct<span class='caret'></span></a><div class='toggleable-list-text'><p>By using this website and the associated services, you automatically agree not to engage in any of the following activities:</p><ul><li><p><b>Violating laws and rights:</b> You may not (a) use any services on this site for any illegal purpose or in violation of any local, state, national, or international laws, (b) violate or encourage others to violate any right of or obligation to a third party, including by infringing, misappropriating, or violating intellectual property, confidentiality, or privacy rights.</p></li><li><p><b>Solicitation:</b> You may not use the Services or any information provided through the Services for the transmission of advertising or promotional materials, including junk mail, spam, chain letters, pyramid schemes, or any other form of unsolicited or unwelcome solicitation.</p></li><li><p><b>Disruption:</b> You may not use this website’s services in any manner that could disable, overburden, damage, or impair the Services, or interfere with any other party’s use and enjoyment of the Services; including by (a) uploading or otherwise disseminating any virus, adware, spyware, worm or other malicious code, or (b) interfering with or disrupting any network, equipment, or server connected to or used to provide any of the Services, or violating any regulation, policy, or procedure of any network, equipment, or server.</p></li><li><p><b>Harming others:</b> You may not post or transmit Content on or through the Services that is harmful, offensive, obscene, abusive, invasive of privacy, defamatory, hateful or otherwise discriminatory, false or misleading, or incites an illegal act; You may not intimidate or harass another through the Services; and, You may not post or transmit any personally identifiable information about persons under 13 years of age on or through the Services.</p></li><li><p><b>Impersonation or unauthorized access:</b> You may not impersonate another person or entity, or misrepresent your affiliation with a person or entity when using the Services; You may not use or attempt to use another’s account or personal information; and you may not attempt to gain unauthorized access to the Services, or the computer systems or networks connected to the Services, through hacking password mining or any other means.</p></li></ul><p>In Summary - Play nice. Be yourself. Don’t break the law or be disruptive.</p></div></li><li><a name='block-10'>10. Uploading Photos, Videos and Other Content on the Website<span class='caret'></span></a><div class='toggleable-list-text'><p>By uploading any photograph, video or other content in relation to your Service Profile and/or personal profile, you automatically warrant that:</p><ul><li><p>You are the only author and owner of the intellectual property rights of the Uploaded content</p></li><li><p>All “moral rights” that you may have in such uploaded content, for example, the right to be named as the creator of your photograph, have been voluntarily waived by you;</p></li><li><p>The uploaded content, primarily photographs/videos, have not been previously licensed, published, distributed or publicly used or displayed without your consent</p></li><li><p>Photographs/videos are not obscene, defamatory or otherwise unlawful, or likely to damage our reputation, and those of others using the site and website services</p></li><li><p>No use of the photographs, videos or other content by us shall cause us to infringe the rights (including the intellectual property rights) of any third party; and</p></li><li><p>Use of the content you supply does not violate these Terms</p></li></ul><p>Furthermore, you agree that your content does not contain any images, connotations or material that:</p><ul><li><p>Disparages any person, us and/or any of our affiliates’ products or other companies, organizations and/or service providers</p></li><li><p>Violates or infringes upon the copyrights, trademarks, right of privacy, right of publicity or other intellectual property or proprietary rights of any person or entity;</p></li><li><p>Includes brand names, copyrighted work or trademarks/logos that may infringe on rights of any third party;</p></li><li><p>Appears to intentionally duplicate any other service profiles</p></li><li><p>Is tortuous, defamatory, slanderous or libellous;</p></li><li><p>Promotes bigotry, racism, sexism, hatred or harm against any group or individual or promotes discrimination based on race, sex, religion, nationality, disability, sexual orientation or age;</p></li><li><p>Contains any personally identifiable information, such as personal names or email addresses;</p></li><li><p>Promotes alcohol, illegal drugs, tobacco, firearms/weapons (or the use of any of the foregoing);</p></li><li><p>Promotes any activities that may appear unsafe or dangerous;</p></li><li><p>Is unlawful or in violation of any law;</p></li><li><p>Contains any nudity, sexually explicit, lewd, offensive, disparaging or other inappropriate content;</p></li><li><p>Is inappropriate or unsuitable to be uploaded to this Website for any reason whatsoever; or</p></li><li><p>Communicates messages or images inconsistent with the positive images and/or goodwill with which we wish to be associated</p></li></ul><p>We reserve the right in our absolute discretion to withdraw or suspend the uploading feature on Service prover and service profiles, and to remove any photographs, videos or other content you have uploaded without prior warning if you are in our sole opinion in breach of any of the above Terms.</p><p>By uploading any photograph, video or other content you are agreeing that we (and our group and affiliate companies and/or organisations) may display the content on our site and any other site or app we may choose at any time, and that when displayed we may include your name as submitted by you in the uploading process. Your content may be posted or displayed publicly on other websites selected by us for viewing by visitors to that website’s public location. We are not responsible for any unauthorised use of your photograph, video or other content by visitors.</p><p>By uploading any photograph, video or other content you are agreeing that we may at any time edit, publish and use your content in any and all media (now or later developed) for promotion, news and information purposes and as part of the website services, without any payment to you.</p><p>We do not guarantee that you will have recourse to edit or delete any photographs, videos or other content that you have uploaded.</p></div></li><li><a name='block-11'>11. Links to this Website<span class='caret'></span></a><div class='toggleable-list-text'><p>You may not create a link to any page of this website without our prior written consent. If you do create a link to a page of this website you do so at your own risk and the exclusions and limitations set out above will apply to your use of this website by linking to it.</p></div></li><li><a name='block-12'>12. Links from this Website<span class='caret'></span></a><div class='toggleable-list-text'><p>Where our site displays and provides links to other websites, apps and resources provided by third parties, these are provided for your information only. We do not monitor or review the content of other party’s websites which are linked from this website and therefore have no control over the contents of those sites or resources, or how they handle any links we provide to them. We accept no responsibility for them or for any loss or damage that may arise from your use of these links.</p><p>Opinions expressed or material appearing on websites which are linked to from this website, are not necessarily shared or endorsed by us. We should not be regarded as the publisher of such opinions or material. Please be aware that we are not responsible for the privacy practices, or content, of these external websites. We encourage our users to be aware when they leave our site and to read the privacy statements of these sites. You should evaluate the security and trustworthiness of any other site connected to this site or accessed through this site yourself, before disclosing any personal information to them. We will not accept any responsibility for any loss or damage in whatever manner, howsoever caused, resulting from your disclosure to third parties of personal information.</p></div></li><li><a name='block-13'>13. Updates<span class='caret'></span></a><div class='toggleable-list-text'><p>We reserve the right to update these terms and conditions from time to time. It's your responsibility to ensure that you're always aware of our latest terms. Every time you use this website, the Terms in force at that time will apply</p></div></li><li><a name='block-14'>14. Our Liability to you<span class='caret'></span></a><div class='toggleable-list-text'><p>This website is a free, open-source service and will remain available to everyone with access to the Internet. They are not intended as an advertising platform for service providers or for any other related commercial or business purposes. In the case that you choose to use this website for commercial or business purposes, we will not be held liable for any loss of profit, loss of business, business interruption or loss of business opportunity as a result of using this site and its related services.</p></div></li><li><a name='block-15'>15. Our Communication<span class='caret'></span></a><div class='toggleable-list-text'><p>All correspondence between us will occur primarily through email. If you wish to contact us, please do so via the email provided in the <a href=\"#todo\">Contact Us[TODO]</a> page. We will confirm we have received your email by contacting you in return, by email.</p><p>In the case that we need to contact you, we will do so by email to the email address you have provided upon registering with us.</p></div></li><li><a name='block-16'>16. Other Important Terms<span class='caret'></span></a><div class='toggleable-list-text'><p>Be advised that we may, at any time, transfer our rights and obligations to this website under a Contract to another organisation, but this will not affect your rights or our obligations under these Terms.</p><p>Each of the paragraphs of these Terms operates separately. If any court or relevant authority decides that any of them are unlawful or unenforceable, the remaining paragraphs will remain in full force and effect.</p><p>If we fail to insist that you perform any of your obligations under these Terms, or if we do not enforce our rights against you, or if we delay in doing so, that will not mean that we have waived our rights against you and will not mean that you do not have to comply with those obligations. If we do waive a default by you, we will only do so in writing, and that will not mean that we will automatically waive any later default by you.</p></div></li><li><a name='block-17'>17. Contacts<span class='caret'></span></a><div class='toggleable-list-text'><p>If you have any questions, concerns, or suggestions regarding these terms, please <a href=\"#todo\">Contact Us[TODO]</a></p></div></li></ul>",
page_contents = [
  {
    name: 'about',
    title: {
      en: 'About Sheaghe'
    },
    header: {
      en: 'About Sheaghe'
    },
    content: {
      en: '<p>You can use Sheaghe to search for any type of rehab service in Georgia. We have a whole database of service providers on the website; each of them registered according to their location, category of service and the types of service they provide.</p> <p>Using the search tool on the home page of Sheaghe, you can search for registered services by name, region, exact address, or by using keywords that describe the service you are looking for. Alternatively, or for a broader search, you can browse the categories of service, all of which are listed on the right hand side of the home page.</p> <p>Once your search results appear on the map, simply click on the marker to learn more about that specific service. From here, you can also follow the link to the Service Provider’s profile page, which gives you more detailed information about the services they provide as well as how to find them. You can also message the service provider directly through Sheaghe by using the instant messaging feature at the bottom of the Service Provider’s Profile page.</p> <p>If you are a service provider and would like to know more about registering your services on Sheaghe, please see <a href="/en/faq#register-service">here</a></p>'
    }
  },
  {
    name: 'faq',
    title: {
      en: 'FAQ'
    },
    header: {
      en: 'Frequently Asked Questions (FAQ)'
    },
    content: {
      en: ''
    },
    items: [
      {
        title: { en: 'What is Sheaghe?' },
        content: { en: "<p>Rehab GE is a free online database that allows you to search for rehab services in and around your community, city or region within the country of Georgia. The website is based on a map, which uses markers to show the exact location of the services you are searching for. For more information about how this works, see <a href=\"#block-2\">here</a></p>" }
      },
      {
        title: { en: 'How does it work?' },
        content: { en: "<p>You can use Rehab GE to search for any type of rehab service in Georgia. We have a whole database of service providers on the website; each of them registered according to their location, category of service and the types of service they provide. Using the search tool on the home page of Rehab GE, you can search for registered services by name, region, exact address, or by using keywords that describe the service you are looking for. Alternatively, or for a broader search, you can browse the categories of service, all of which are listed on the right hand side of the home page. Once your search results appear on the map, simply click on the marker to learn more about that specific service. From here, you can also follow the link to the Service Provider’s profile page, which gives you more detailed information about the services they provide as well as how to find them. You can also message the service provider directly through Rehab GE by using the instant messaging feature at the bottom of the Service Provider’s Profile page.</p><p>If you are a service provider and would like to know more about registering your services on RehabGE, please see <a href=\"#block-9\">here</a></p>" }
      },
      {
        title: { en: 'How do I use it?' },
        content: { en: "<p>Rehab GE helps you search for all types of rehabilitation services in the country of Georgia. The key features of the site include the map, the search tool and the list of Categories. From the home page, you can search for services registered on Rehab GE in one of two ways:</p><ul class='numbered'><li><p>1. Using the search tool at the top of the page; simply type in the region or a keyword related to the service you are looking for (or both!) and hit enter; OR</p></li>
          <li><p>2. By directly clicking a category from the list of service categories listed on the right hand side of the screen</p></li>
          </ul>
          <p>The services you are looking for should appear on the map as a coloured marker. Click on the markers to find out more about the services and follow the links to the Service Provider’s profile page.</p><p>You can use Rehab GE on your computer, tablet or mobile device. For the moment, it’s only available online and with proper Internet connection, but we are working on making it accessible offline too!</p>" }
      },
      {
        title: { en: 'How do I sign up?' },
        content: { en: "<p>You can sign up by clicking the \"Sign up or Sign in\" button on the top left hand side of the home page. From there you need to follow the instructions and fill out the form to create an account. It’s as easy as that!</p><p>Click <a href=\"sign_up\">here</a> if you want to be automatically redirected to the Sign Up page.</p>" }
      },
      {
        title: { en: 'Why would I want to sign up?' },
        content: { en: "<p>Signing up gives you access to some additional features of Rehab GE that allow you to:</p><ul><li><p>Send instant messages to registered service providers</p></li>
          <li><p>Save a list of Favorite services, so you don’t have to search for them every time</p></li>
          <li><p>If you are a service provider you will be able to update and edit your service profile as well as register additional services on the site at any time</p></li>
          </ul><p>By signing up we know that you are a human being! Every profile opened helps us get an idea of what you like and don’t like about Rehab GE so we can improve the site and services to better suit your needs.</p>" }
      },
      {
        title: { en: 'Can anyone Sign up? What if I don’t live in Georgia?' },
        content: { en: "<p>Sure!</p><p>Rehab GE is completely free and open source. As long as you have an internet connection and a computer, tablet or mobile device, you are welcome to sign up – even if you don’t live in Georgia. If you live outside Georgia and would like to see a website like this in your own country or Region, see <a href=\"#todo\">here[TODO]</a> for more information.</p>" }
      },
      {
        title: { en: 'I am a service provider, how can I get my service to show up on Rehab GE?' },
        content: { en: "<p>If you are a service provider and your service is not already registered on Rehab GE you will need to Sign up <a href=\"sign_up\">here</a> before you can register your service. Be sure to indicate that you are a service provider when you Sign up to receive further instructions about registering services.</p><p>If you are already signed up, simply press the Register Services button on the right hand side of the home page and follow the instructions on the Registration.</p><p>Be aware that we review every single registration to make sure they are accurate and real. This takes time, usually around two weeks, so please be patient! We will contact you to let you know if your registration is successful – that means people will be able to search for you on Rehab GE.</p>" }
      },
      {
        title: { en: 'I am a service provider, what do I do if my service is already on Rehab GE?' },
        content: { en: "<p>Congratulations! This means your service was pre-registered on Rehab GE, making it more accessible to a greater number of Georgians searching for rehabilitation services.</p><p>As a pre-registered service provider, you would have been contacted by the Rehab GE team and given written and / or verbal consent to having your service registered on the site. To complete the full validation of your service, you will need to <a href=\"sign_up\">Sign Up</a> and open an account. Once your account is activated, you can link the service to your personal account by clicking the link on the service information page. Activating the account will enable you to edit and update your personal profile as well as the information about your service. It will also turn on the instant messaging function, so that other registered users will be able to get in touch with you directly through the website.</p><p>If you would like to be automatically re-directed to the Sign Up page, please click <a href=\"sign_up\">here</a>. If you still need more information or are not sure why your service is registered on Rehab GE, please <a href=\"#todo\">Contact Us[TODO]</a>.</p>" }
      },
      {
        title: { en: 'I am trying to register my services, but the button on the home screen is not working. What do I do now?' },
        content: { en: "<p>The register services function is only available to registered users.</p><p>You will need to <a href=\"sign_up\">Sign Up</a> and open an account with us before you can register your service. If you are already registered, make sure you are signed in, and then try the Register Services button again from the home page. If the button is still not working or the links appear to be broken, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know what’s going on. Unfortunately, things go wrong from time to time – we apologize for any inconvenience and will do our best to fix the problem as soon as possible!</p>" }
      },
      {
        title: { en: 'I am trying to message a service provider, but the message box is not working' },
        content: { en: "<p>The Instant messaging feature is only available to registered users.</p><p>You will need to <a href=\"sign_up\">Sign Up</a> and open an account with us before you can message service providers through the website. If you are already registered, make sure you are signed in, and then try sending your message again.</p><p>For some services, the message box will be blocked indefinitely. This means the service provider has not validated their account yet or that they prefer to have users contact them by phone or an alternate email. Sometimes it is because they simply do not have an email address. In these cases, you can try calling the provider or visiting them in person. If you are still unsure, you can <a href=\"#todo\">Contact Us[TODO]</a> to check if they are validated or not.</p>" }
      },
      {
        title: { en: 'What do you mean by “validated” service? How is it different from an “un-validated” service?' },
        content: { en: "<p>A “validated” service is one that has been reviewed by Rehab GE and is linked to a registered user on the site. Because they are linked to a user profile, this means you can message the service provider directly through the website using the Instant message box on the service provider’s information page.</p><p>An “un-validated” service has also been reviewed by Rehab GE to make sure it is real before being added to the database, but the service provider does not have a profile on Rehab GE. This means you cannot message them instantly through the website, but you can still get in touch by calling the phone number or visiting them in person. In some cases, a different email address may be provided on the service provider page so you can try sending an email the traditional way.</p>" }
      },
      {
        title: { en: 'I want to Sign Up, but what if I don’t want to give my address or contact details?' },
        content: { en: "<p>No problem!</p><p>Just leave these sections empty when you are filling out the profile page. You will still need to provide a working email address in order to sign up, but this is so we can make sure you are a real person using the website. We will not use your email address to send spam or any other promotional information, ever. Please read our <a href=\"privacy_policy\">Privacy Policy</a> if you want to know more about it.</p><p>If you are a service provider, you are also free to leave the contact details empty, but remember that the more contact information you provide, the easier it will be for people to find you. We understand that you may not want people to email your personal account, which is why we recommend using a company email address, or opening a new email account that you can use on Rehab GE.</p>" }
      },
      {
        title: { en: 'There are so many services listed! How do you make sure they are really providing what they claim?' },
        content: { en: "<p>All services and service providers are reviewed by the Rehab GE team before you are able to search for them on the website. This means we have called, visited or checked the service through someone else to make sure they are real and actively providing the services they say they are. Making sure the information stays accurate and up to date is a little bit trickier, but we have a system in place to make sure the service providers are active in updating their information page on a regular basis.</p><p>If you see a service provider on Rehab GE that you think is giving the wrong information about their services or is no longer operational, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know all about it. We will personally follow up every claim.</p>" }
      },
      {
        title: { en: 'OK, I’ve found the service I need! How can I be sure it is still available?' },
        content: { en: "<p>The best way to make sure is to contact them! You can do this by calling them, sending them an email or sending an instant message through the website. If it is convenient for you, you can even go there in person.</p><p>As much as we try to make sure that all the services registered on Rehab GE are still functioning and up to date, we acknowledge that some might still slip through the cracks. We also cannot guarantee the quality of the services they provide. If you see a service provider on Rehab GE that you think is giving the wrong information about their services or is no longer operational, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know all about it. We will personally follow up every claim.</p>" }
      },
      {
        title: { en: 'I sent an Instant message to the service provider. It’s been a long time and I still have no reply from them. What can I do?' },
        content: { en: "<p>Unfortunately there’s not a whole lot you can do. The instant message is sent to an email account, so it might be that the service provider is away or unable to reply at this time. Some service providers offer a different email address and telephone number on their information page. If you haven’t already, we suggest you give them a try.  If there is still no response, or you have a feeling that the service is no longer operational, please let us know <a href=\"#todo\">here[TODO]</a>.</p>" }
      },
      {
        title: { en: 'What are all the colored markers with icons?' },
        content: { en: "<p>The colored markers indicate the category of service that is associated with the registered services. You will notice that some service providers are linked to more than one category – this is so that they are easier to search for. The colors themselves have no particular meaning, but the symbols do relate to the category in some way so that they are easily recognizable.</p><p>If you have any feedback or questions about the markers or the colors we have chosen, please <a href=\"#todo\">Contact Us[TODO]</a> and let us know what you think.</p>" }
      },
      {
        title: { en: 'What do the circles with numbers mean on the map?' },
        content: { en: "<p>These are the number of services related to your search category that are available in a single location. We have condensed them to make it more visually appealing. Click on the number to zoom in and find out more about the services available in that location.</p>" }
      },
      {
        title: { en: 'Is this website only for Georgia? Is it available in any other countries?' },
        content: { en: "<p>At the moment, Rehab GE is focused on rehabilitation services available only in the country of Georgia. This is reflected in the map on our home screen. Other countries might have similar websites, offering similar services, but we have no association with them.</p>" }
      },
      {
        title: { en: 'Is it only in Georgian and English?' },
        content: { en: "<p>Yes, at this time the only languages are Georgian and English</p>" }
      },
      {
        title: { en: 'Is Rehab GE only available Online? What if I need to use it and I don’t have an internet connection?' },
        content: { en: "<p>Yes, at the moment Rehab GE is only available online, but we are working to fix that!</p><p>You can use it on your mobile device if you have access to data; however the site might work a bit slower than usual.</p>" }
      },
      {
        title: { en: 'Is there a Rehab GE app?' },
        content: { en: "<p>Unfortunately there is no app, yet – we are working on it!</p>" }
      },
      {
        title: { en: 'I want to develop a website like this for my country / region! How do I do it?' },
        content: { en: "<p>Great!  You can find all the information you need to start your own version of Rehab GE on Github. Click <a href=\"#todo\">here[TODO]</a> to access the information. Feel free to <a href=\"#todo\">Contact Us[TODO]</a> for more information about developing your own version of this website.</p>" }
      }
    ]
  },
  {
    name: 'privacy_policy',
    title: {
      en: 'Privacy Policy'
    },
    header: {
      en: 'Privacy Policy'
    },
    content: {
      en: "<p>At Rehab GE, we are committed to protecting your privacy. Only those authorized as Administrators of the website are able to view and use information relating to all users – registered and unregistered – on the website.</p>"
    },
    items: [
      {
        title: { en: "Data Collection and information Use" },
        content: { en: "<ul>
          <li><p>Rehab GE collects information and data about service users and Service providers that have Services Registered with the Rehab GE database.</p></li>
          <li><p>All data and information that is collected through Rehab GE will be reviewed carefully by the administrators and remain confidential. The ultimate purpose of collecting any data and information about services and service users on this site will be to Improve the services offered through Rehab GE and to Identify the needs in regards to rehabilitative services throughout the country of Georgia.</p></li>
          <li><p>Any other data collected on the site is purely for the purpose of running the site and will not be shared, rented or sold.</p></li>
          <li><p>Rehab GE will not rent, sell, or share information about you with other people or non-affiliated companies or organizations.</p></li></ul>" }
      },
      {
        title: { en: "Contact and Instant Messaging service" },
        content: { en: "<ul>
          <li><p>We reserve the right to send Service providers, that have rehabilitative services Registered on the website, certain communications relating to Rehab GE such as service announcements, administrative messages relating to their registration and Information page and any other messages that are considered essential to the functioning of the Rehab GE website without offering you the opportunity to opt out of receiving them</p></li>
          <li><p>Instant messages sent through the site are one-off events. We will not distribute any email addresses to any third party or associated organization(s) of Rehab GE or use them for anything other than their intended purpose. See <a href=\"terms_of_use\">Terms of Use</a> for more information about the purpose of the site and Instant messaging system for Registered Users.</p></li>
          <li><p>Any messages sent through the Instant messaging feature on Rehab GE are delivered directly to the inbox of the email specified by the Service provider. Rehab GE will not be able to view or edit the Instant messages before the Service Provider receives them. Rehab GE will therefore take no responsibility In the case that any offensive of inappropriate content is sent and received by the Service Provider through this instant messaging service. In such cases, it is the responsibility of the Service provider to contact the Rehab GE team of the breach of Terms of use. In such cases Rehab GE will take whatever action possible to attempt to rectify the situation.</p></li>
          <li><p>Once received, Service Providers are responsible for responding to the Instant Messages from Service Users within a reasonable timeframe and in an acceptable manner which is in accordance with the Terms of Use of this website and Privacy Policy. In the case that a Service User has received an offensive email or any inappropriate content from the Service Provider they are responsible for immediately notifying the Rehab GE Administrators of the situation.</p></li></ul>" }
      },
      {
        title: { en: "Confidentiality and Security" },
        content: { en: "<p>At Rehab GE we limit access to personal information about you to authorized administrators of the website who need to view this information in order to advise and assist in the development of services that will better serve the users and their needs.</p>" }
      },
      {
        title: { en: "Changes to this Privacy Policy" },
        content: { en: "<p>Rehab GE may update this policy from time to time. We are not required to inform of any minor changes, however if there is what we consider to be a significant change to the way in which we treat your personal information, we may inform you by sending an email to the email address that is associated with your Rehab GE account or by placing a prominent notice on our site</p>" }
      },
      {
        title: { en: "Copyright Complaints" },
        content: { en: "<p>Rehab GE respects copyright, and we prohibit users of our Services from submitting, uploading, posting, or otherwise transmitting any Content on the Services that violates another person’s proprietary rights.</p><p>To report anything that you believe may be an infringement of copyright laws, please inform the Administrative Team immediately via email. Contact information can be found on the <a href=\"#todo\">Contact Us[TODO]</a> page.</p>" }
      },
      {
        title: { en: "Termination" },
        content: { en: "<p>By Rehab GE: We reserve the right to modify, suspend, or terminate the operation of, or access to, all or any of the Services provided through this website at any time and for any reason. In addition your individual access to, and use of, the Services may be terminated at any time, for any reason by the Rehab GE Administrative Team. In the case that such an event does occur, we will contact you by email to your verified email address that is associated with your Personal Account.</p><p>By you: If you wish to terminate this agreement, you may immediately stop accessing or using the Services at any time. The procedure for closing your account is described in <a href=\"terms_of_use\">Terms of Use</a></p><p>Automatic upon breach: Your right to access and use the Services offered on Rehab GE terminates automatically upon your breach of any of the <a href=\"terms_of_use\">Terms of Use</a>.</p>" }
      }
    ]
  },
  {
    name: 'terms_of_use',
    title: {
      en: 'Terms of Use'
    },
    header: {
      en: 'Terms of Use'
    },
    content: {
      en: "<p>This page tells you all about us and the legal terms and conditions related to the use of this website. Please read them carefully and make sure you understand all the information before using any of our. By choosing to use this online service, and by registering as a service provider on this site, you automatically agree to abide by the terms and conditions stated below.</p><p>It is advised for you to print a copy of this page for future reference.</p><p>Note that from time to time, we may need to change, remove or add to the Terms. Therefore you are advised to please check the Terms each time you wish to use this site to make sure you understand the terms that apply at the time.</p>"
    },
    items: [
      {
        title: { en: "Definitions" },
        content: { en: "<p>In these terms:</p><ul>
          <li><p>“User” means any individual using the website to search for rehabilitation services. This includes both registered and unregistered users as well as Service Providers and Administrators</p></li>
          <li><p>“Registered User” Any user that has signed up and established an account on Rehab GE. They will have access to additional features of the site including Instant messages to the Service provider through the website and ability to build a Favorites list.</p></li>
          <li><p>“Services” or “Website Services” includes all functions and features that are available to Users on the Rehab GE website. This includes, but is not limited to search for services, User registration, Favorites feature and Instant messaging to services</p></li>
          <li><p>“Registered Service” is any rehabilitation service that is searchable through the Rehab GE search function located on the home screen. Registered services have all been verified for accuracy of information and contact details prior to publishing.</p></li>
          <li><p>“Service Provider” is any individual with a registered account that has a verified rehabilitation service that is searchable by other Rehab GE users. They also have their email address linked to the Instant messaging feature on the information page about their service. This allows other users to message them directly through the Rehab GE website. Service providers have additional responsibilities in ensuring the details of their services and email address remain accurate and up to date. Please see <a href=\"#todo\">Participating in our community – Registered Users[TODO]</a> for further information.</p></li>
          <li><p>“Published” means that the service is searchable through the Rehab GE database</p></li>
          <li><p>“Administrator” means user that has the authority to access additional features of Rehab GE as well as regulate information about services that is published on the site and is searchable by other users</p></li>
          <li><p>“Content” is anything that can be uploaded to the site by users or administrators, including but not limited to, written information, instant messages, photographs, images, videos and links to other sites</p></li>
          <li><p>“Instant message” is the message sent directly to the service provider using the message box on the Service provider information page</p></li></ul>" }
      },
      {
        title: { en: "Information about us" },
        content: { en: "<p>We are the McLain Association for Children (MAC), and are the organization responsible for establishing and operating this website. Together with the Ministry of Health, Georgia we are the main Administrators of this site. For any queries, you may find all the necessary contact information on our Contact Us page.</p>" }
      },
      {
        title: { en: "Participating in our Community – Registered Users" },
        content: { en: "<p>As a user of this website, you are responsible for:</p><ul>
          <li><p>Making all the necessary arrangements for you to have access to the site</p></li>
          <li><p>Opening and account and completing your profile using your own personal information at your own discretion (through the use of an alias or nickname if desired)</p></li>
          <li><p>Provide personal information, with the understanding that it may be used in collecting data (by MAC, the MoH and any other partner organization authorized by the administration of this Website) with the aim of improving the availability and quality of rehabilitation services in the country of Georgia</p></li>
          <li><p>Maintain the security of your passwords and identification</p></li>
          <li><p>Be fully responsible for all the uses of your account</p></li></ul><p>In addition, as a Service Provider and with services registered on this website, you have indicated that you:</p><ul>
          <li><p>By providing your email address and upon confirmation of your account, you automatically consent to receiving instant messages through the website. For more information about the Instant messaging feature, please see – 4. Instant Messaging Feature for Service providers.</p></li>
          <li><p>You will update your personal information and email address as required, in order to maintain the accuracy of information provided on the site as well as the integrity of the instant messaging feature offered through your service profile</p></li>
          <li><p>Agree to receive regular emails (at a minimum, every 6 months) to the email address specified in your profile requesting you to review and update the information about your services</p></li>
          <li><p>Agree to allow all the updated information relating to your services to be reviewed and authorized by the administrators of this website before being published</p></li></ul><p>User accounts must not be set up on behalf of another Individual user, service provider or any other entity unless you have their prior consent and are authorized to do so. Please see the Privacy Policy for more information about Privacy and Confidentiality.</p>" }
      },
      {
        title: { en: "Instant Messaging Service for Service providers" },
        content: { en: "<p>This feature enables only Registered users to message the service provider through the message box on the Services profile page. Note that:</p><ul>
          <li><p>Only Registered users are able to make use of the Instant messaging feature</p></li>
          <li><p>The Instant message will be received only by the Service Provider and will not be viewed by any other third Party, including the administrators.</p></li>
          <li><p>The message will be automatically directed to the inbox of the email provided by the Service provider. The Service provider is therefore responsible for ensuring their email address and contact details are correct and up to date at all times</p></li>
          <li><p>Upon receiving the message, the Service Provider is required to respond appropriately to the user request.</p></li></ul><p>All Registered Users are expected to abide by these terms and Fair use when taking part in the Instant Messaging feature of this website. Inappropriate email exchanges from either service providers or registered service users will not be tolerated under any circumstances. In the case that inappropriate language or content is received by either user, they are responsible for informing the website administrator immediately. Contact details can be found here [link to Contact Us]</p>" }
      },
      {
        title: { en: "Closing of Accounts" },
        content: { en: "<p>The administrators of this website reserve the right to modify or discontinue your account at any time for any reason or no reason at all.</p><p>If you wish to close your account, you may do so by -???</p>" }
      },
      {
        title: { en: "Business deletion" },
        content: { en: "<p>We reserve the right to remove any Registered Services profiles if we feel that they're infringing on any laws or if they contain objectionable material such as adult content (including images, vulgar language, content or links). Please Read the section on Prohibited Conduct for further information on acceptable content and conduct on this Website.</p>" }
      },
      {
        title: { en: "How we use your personal information" },
        content: { en: "<p>All personal information you provide on this website is used in accordance with our <a href=\"privacy_policy\">Privacy Policy</a>. We make every possible attempt to keep your personal information safe, however you should be aware that this site, as well as any other site could potentially be a target for hackers. Please avoid posting any sensitive or private information that you would not want disclosed in the case of an unlikely security breach.</p><p>Rehab GE is a website that collects general data and statistics about the use of the website, with the aim of improving overall services offered through the website. We are committed to responsibly handling the information and data collected through our website and the website services. Please review the <a href=\"privacy_policy\">Privacy Policy</a> for more information about how data is collected and used from this website and services. Please take the time to read this as it does contain important terms that apply to you and all registered users of this site.</p><p>Please note that we will not sell, share or rent your personal information to any third party or use your email or mailing address for unsolicited mail. Any emails, messages or other information sent by us will only be in relation to the provision of agreed services on this website.</p>" }
      },
      {
        title: { en: "Fair use of our Site" },
        content: { en: "<p>We are not responsible for any damages caused by the use of this website, or by registering and advertising your rehabilitation services here. Please use our site at your own discretion and exercise good judgment as well as common sense when registering services and contacting service providers through the instant messaging function.</p><p>Access to the site is permitted on a temporary basis and we reserve the right to withdraw or amend the services and information we provide on our site without prior notice. We also reserve the right to alter the content of this site without communicating the alterations to the users, be they registered or unregistered. We will not be liable for any reason the site is unavailable at any time or for any period. Note that from time to time, we may restrict access to some parts of the site or block service profiles from being visible on the map. This applies to all users, including Registered Users and Services.</p><p>Please be aware that although we strive to include only accurate information about the rehabilitation services on our site, the material provided comes with no guarantees or warranties as to its accuracy.</p>" }
      },
      {
        title: { en: "Prohibited Conduct" },
        content: { en: "<p>By using this website and the associated services, you automatically agree not to engage in any of the following activities:</p><ul>
          <li><p><b>Violating laws and rights:</b> You may not (a) use any services on this site for any illegal purpose or in violation of any local, state, national, or international laws, (b) violate or encourage others to violate any right of or obligation to a third party, including by infringing, misappropriating, or violating intellectual property, confidentiality, or privacy rights.</p></li>
          <li><p><b>Solicitation:</b> You may not use the Services or any information provided through the Services for the transmission of advertising or promotional materials, including junk mail, spam, chain letters, pyramid schemes, or any other form of unsolicited or unwelcome solicitation.</p></li>
          <li><p><b>Disruption:</b> You may not use this website’s services in any manner that could disable, overburden, damage, or impair the Services, or interfere with any other party’s use and enjoyment of the Services; including by (a) uploading or otherwise disseminating any virus, adware, spyware, worm or other malicious code, or (b) interfering with or disrupting any network, equipment, or server connected to or used to provide any of the Services, or violating any regulation, policy, or procedure of any network, equipment, or server.</p></li>
          <li><p><b>Harming others:</b> You may not post or transmit Content on or through the Services that is harmful, offensive, obscene, abusive, invasive of privacy, defamatory, hateful or otherwise discriminatory, false or misleading, or incites an illegal act; You may not intimidate or harass another through the Services; and, You may not post or transmit any personally identifiable information about persons under 13 years of age on or through the Services.</p></li>
          <li><p><b>Impersonation or unauthorized access:</b> You may not impersonate another person or entity, or misrepresent your affiliation with a person or entity when using the Services; You may not use or attempt to use another’s account or personal information; and you may not attempt to gain unauthorized access to the Services, or the computer systems or networks connected to the Services, through hacking password mining or any other means.</p></li></ul><p>In Summary - Play nice. Be yourself. Don’t break the law or be disruptive.</p>"  }
      },
      {
        title: { en: "Uploading Photos, Videos and Other Content on the Website" },
        content: { en: "<p>By uploading any photograph, video or other content in relation to your Service Profile and/or personal profile, you automatically warrant that:</p><ul>
          <li><p>You are the only author and owner of the intellectual property rights of the Uploaded content</p></li>
          <li><p>All “moral rights” that you may have in such uploaded content, for example, the right to be named as the creator of your photograph, have been voluntarily waived by you;</p></li>
          <li><p>The uploaded content, primarily photographs/videos, have not been previously licensed, published, distributed or publicly used or displayed without your consent</p></li>
          <li><p>Photographs/videos are not obscene, defamatory or otherwise unlawful, or likely to damage our reputation, and those of others using the site and website services</p></li>
          <li><p>No use of the photographs, videos or other content by us shall cause us to infringe the rights (including the intellectual property rights) of any third party; and</p></li>
          <li><p>Use of the content you supply does not violate these Terms</p></li></ul><p>Furthermore, you agree that your content does not contain any images, connotations or material that:</p><ul>
          <li><p>Disparages any person, us and/or any of our affiliates’ products or other companies, organizations and/or service providers</p></li>
          <li><p>Violates or infringes upon the copyrights, trademarks, right of privacy, right of publicity or other intellectual property or proprietary rights of any person or entity;</p></li>
          <li><p>Includes brand names, copyrighted work or trademarks/logos that may infringe on rights of any third party;</p></li>
          <li><p>Appears to intentionally duplicate any other service profiles</p></li>
          <li><p>Is tortuous, defamatory, slanderous or libellous;</p></li>
          <li><p>Promotes bigotry, racism, sexism, hatred or harm against any group or individual or promotes discrimination based on race, sex, religion, nationality, disability, sexual orientation or age;</p></li>
          <li><p>Contains any personally identifiable information, such as personal names or email addresses;</p></li>
          <li><p>Promotes alcohol, illegal drugs, tobacco, firearms/weapons (or the use of any of the foregoing);</p></li>
          <li><p>Promotes any activities that may appear unsafe or dangerous;</p></li>
          <li><p>Is unlawful or in violation of any law;</p></li>
          <li><p>Contains any nudity, sexually explicit, lewd, offensive, disparaging or other inappropriate content;</p></li>
          <li><p>Is inappropriate or unsuitable to be uploaded to this Website for any reason whatsoever; or</p></li>
          <li><p>Communicates messages or images inconsistent with the positive images and/or goodwill with which we wish to be associated</p></li></ul><p>We reserve the right in our absolute discretion to withdraw or suspend the uploading feature on Service prover and service profiles, and to remove any photographs, videos or other content you have uploaded without prior warning if you are in our sole opinion in breach of any of the above Terms.</p><p>By uploading any photograph, video or other content you are agreeing that we (and our group and affiliate companies and/or organisations) may display the content on our site and any other site or app we may choose at any time, and that when displayed we may include your name as submitted by you in the uploading process. Your content may be posted or displayed publicly on other websites selected by us for viewing by visitors to that website’s public location. We are not responsible for any unauthorised use of your photograph, video or other content by visitors.</p><p>By uploading any photograph, video or other content you are agreeing that we may at any time edit, publish and use your content in any and all media (now or later developed) for promotion, news and information purposes and as part of the website services, without any payment to you.</p><p>We do not guarantee that you will have recourse to edit or delete any photographs, videos or other content that you have uploaded.</p>" }
      },
      {
        title: { en: "Links to this Website" },
        content: { en: "<p>You may not create a link to any page of this website without our prior written consent. If you do create a link to a page of this website you do so at your own risk and the exclusions and limitations set out above will apply to your use of this website by linking to it.</p>" }
      },
      {
        title: { en: "Links from this Website" },
        content: { en: "<p>Where our site displays and provides links to other websites, apps and resources provided by third parties, these are provided for your information only. We do not monitor or review the content of other party’s websites which are linked from this website and therefore have no control over the contents of those sites or resources, or how they handle any links we provide to them. We accept no responsibility for them or for any loss or damage that may arise from your use of these links.</p><p>Opinions expressed or material appearing on websites which are linked to from this website, are not necessarily shared or endorsed by us. We should not be regarded as the publisher of such opinions or material. Please be aware that we are not responsible for the privacy practices, or content, of these external websites. We encourage our users to be aware when they leave our site and to read the privacy statements of these sites. You should evaluate the security and trustworthiness of any other site connected to this site or accessed through this site yourself, before disclosing any personal information to them. We will not accept any responsibility for any loss or damage in whatever manner, howsoever caused, resulting from your disclosure to third parties of personal information.</p>" }
      },
      {
        title: { en: "Updates" },
        content: { en: "<p>We reserve the right to update these terms and conditions from time to time. It's your responsibility to ensure that you're always aware of our latest terms. Every time you use this website, the Terms in force at that time will apply</p>" }
      },
      {
        title: { en: "Our Liability to you" },
        content: { en: "<p>This website is a free, open-source service and will remain available to everyone with access to the Internet. They are not intended as an advertising platform for service providers or for any other related commercial or business purposes. In the case that you choose to use this website for commercial or business purposes, we will not be held liable for any loss of profit, loss of business, business interruption or loss of business opportunity as a result of using this site and its related services.</p>" }
      },
      {
        title: { en: "Our Communication" },
        content: { en: "<p>All correspondence between us will occur primarily through email. If you wish to contact us, please do so via the email provided in the <a href=\"#todo\">Contact Us[TODO]</a> page. We will confirm we have received your email by contacting you in return, by email.</p><p>In the case that we need to contact you, we will do so by email to the email address you have provided upon registering with us.</p>" }
      },
      {
        title: { en: "Other Important Terms" },
        content: { en: "<p>Be advised that we may, at any time, transfer our rights and obligations to this website under a Contract to another organisation, but this will not affect your rights or our obligations under these Terms.</p><p>Each of the paragraphs of these Terms operates separately. If any court or relevant authority decides that any of them are unlawful or unenforceable, the remaining paragraphs will remain in full force and effect.</p><p>If we fail to insist that you perform any of your obligations under these Terms, or if we do not enforce our rights against you, or if we delay in doing so, that will not mean that we have waived our rights against you and will not mean that you do not have to comply with those obligations. If we do waive a default by you, we will only do so in writing, and that will not mean that we will automatically waive any later default by you.</p>" }
      },
      {
        title: { en: "Contacts" },
        content: { en: "<p>If you have any questions, concerns, or suggestions regarding these terms, please <a href=\"#todo\">Contact Us[TODO]</a></p>" }
      }
    ]
  }
]
page_contents.each {|page_content|
  # puts "#{page_content[:name]}"
  d = PageContent.create(name: "#{page_content[:name]}", title_en: page_content[:title][:en], title_ka: page_content[:title][:en])
  # puts d.errors.inspect

  page_content_items = []
  if page_content[:items].present?
    page_content[:items].each_with_index{|item, item_i|
        page_content_items << {
          title_en: item[:title][:en],
          title_ka: item[:title][:en],
          content_en: item[:content][:en],
          content_ka: item[:content][:en],
          order: item_i + 1
        }
    }
    d.update_attributes(page_content_items_attributes: page_content_items)
  end
  I18n.available_locales.each { |locale|

    # byebug
    # puts :title => page_content[:title][locale], header: page_content[:header][locale], :content => page_content[:content][locale], page_content_items_attributes: page_content_items
    Globalize.with_locale(locale) do
      d.update_attributes(header: page_content[:header][:en], :content => page_content[:content][:en])
    end
  }
}


# Adult - Adult Services
# Children - Children's Services
# Education - Inclusive Education
# Legal - Legal Services
# Health - Medical
# Rehabilitation/Habitation - Physical Rehabilitation
# Other Services - Other Services
# Social Benefits - Social Support
# ---
# Psychological
# Community Programs
# Projects and Initiatives
# Sports and Recreation
# Professional Training
# Technical Services
# Youth Services
# Sight, Speech and Hearing

Service.destroy_all
# services = [
#   { icon: 'adult', name: { en: "Adult", ka: "ზრდასრულთა მომსახურება" }, description: { en: "Services offering specialized support and assistance to adults with all types of physical  and intellectual disabilities and/or mental health problems", ka: "სპეციალური სერვისები,რომელიც მიმართულია ყველა ტიპის ფიზიკური და გონებრივი შეზღუდვის მქონე ზრდასრულის მხარდასაჭერად." } },
#   { icon: 'children', name: { en: "Children", ka: "სერვისები ბავშვებისათვის" },  description: { en: "Services offering specialized support and assistance to children with physical and/or intellectual disabilities. This may also include support for their parents and/or carers.", ka: "სერვისები მიმართულია ფიზიკური და/ან გონებრივი შეზღუდვების მქონე ბავშვებზე. ასევე ბავშვის მშობლის/მეურვის მხარდაჭერაზე." } },
#   { icon: 'education', name: { en: "Education", ka: "ინკლუზიური განათლება" },  description: { en: "Educational facilities offering inclusive education for children and/or adults with all types of disabilities", ka: "საგანმანათლებლო დაწესებულებები, რომლებიც სთავაზობენ ინკლუზიურ განათლებას სხვადასხვა შეზღუდვების მქონე ბავშვებსა და მოზარდებს." } },
#   { icon: 'legal', name: { en: "Legal", ka: "სამართლებრივი სერვისები" },  description: { en: "All services and / or organisations dealing with legal aspects of healthcare and rehabilitation, including training and awareness raising", ka: "ორგანიზაციები, რომლებიც მუშაობენ ჯანდაცვის და რეაბილიტაციის სამართლებრივ ასპექტებზე. სერვისები მოიცავს თემისათვის ტრენინგებსა და ცნობიერების ამაღლების აქტივობების განხორციელებას." } },
#   { icon: 'health', name: { en: "Health", ka: "სამედიცინო" },  description: { en: "Services offering specialized medical care, surgery and treatment for people of all ages. This also includes funding support for all medical related services.", ka: "სერვისები,რომელიც მოიცავს სპეციალიზირებულ სამედიცინო დახმარებას, როგორიც არის ოპერაცია და მკურნალობა ნებისმიერი ასაკის ადამიანისათვის. აღნიშნულ სერვისში მოიაზრება სამედიცინო სერვისების დაფინანსებაც." } },
#   { icon: 'rehab', name: { en: "Rehabilitation/Habitation", ka: "ფიზიკური რეაბილიტაცია" }, description: { en: "All types of physical rehabilitation and therapy services", ka: "ყველა ტიპის ფიზიკური რეაბილიტაცია და თერაპიული სერვისი" } },
#   { icon: 'other', name: { en: "Other Services", ka: "სხვა სერვისები" }, description: { en: "Services that are not clearly defined by already established Service Categories", ka: "ის სერვისები,რომელიც არ შეესაბამება არცერთ არსებულ სერვისის კატეგორიას." } },
#   { icon: 'social', name: { en: "Social Benefits", ka: "სოციალური დახმარება" },  description: { en: "Inclusive social groups, activities and/or support services for children and adults", ka: "სოციალური დახმარების პროგრამები ბავშვებისა და მოზრდილებისათვის" } }

  # { icon: 'social', name: { en: "Psychological", ka: "ფსიქოლოგიური" },  description: { en: "All services specialised in providing psychological support, education and programs for children and/or adults", ka: "ნებისმიერი ტიპის ფსიქოლოგიური დახმარება, განათლება და პროგრამები,რომელიც მიმართულია ბავშვებსა და მოზარდებზე. " } },
  # { icon: 'adult', name: { en: "Community Programs", ka: "სათემო პროგრამები" },  description: { en: "Community based programs and initiatives for children and adults, including all types of inclusive activities", ka: "თემზე მორგებული ინკლუზიური ტიპის პროგრამები და ინიციატივები ბავშვებისათვის და მოზრდილთათვის." } },
  # { icon: 'children', name: { en: "Projects and Initiatives", ka: "პროექტები და ინიციატივები" },  description: { en: "Short or long term projects and initiatives focusing on inclusive activities and services", ka: "მოკლე და ხანგრძლივი პროექტები და ინიციატივები, რომელიც მოიცავს ინკლუზიურ აქტივობებსა და სერვისებს." } },
  # { icon: 'education', name: { en: "Sports and Recreation", ka: "სპორტი და რეკრიაცია" }, description: { en: "Sport and recreational programs for children and adults with all types of disabilities. These include long and short term initiatives, as well as one-off events", ka: "სპორტული და რეკრიაციული პროგრამები ყველა ტიპის შეზღუდვების მქონე ბავშვებისა და მოზრდილებისათვის. აქ მოისაზრება როგორ ერთჯერადი, ასევე ხანმოკლე და ხანგრძლივი ინიციატივები." } },
  # { icon: 'legal', name: { en: "Professional Training", ka: "პროფესიული ტრენინგები" }, description: { en: "Offering training programs or courses for health professionals, teachers, parents and carers of people with disability.", ka: "ტრენინგ პროგრამები და კურსები ჯანდაცვის მუშაკთათვის, პედაგოგთათვის, მშობლებისათვის და სხვა მზრუნველი პირებისათვის რომლებიც მუშაობენ შშმ პირებთან." } },
  # { icon: 'other', name: { en: "Technical Services", ka: "ტექნიკური სერვისები" },  description: { en: "Workshops, assembly or manufacturing centers offering technical repairs and other services for medical aids, asistive devices and other medical equipment", ka: "სახელოსნოები, ამწყობი ან მწარმოებელი ცენტრები, რომელიც სთავაზობს სხვადასხვა სამედიცინო და დამხმარე ხელსაწყოების ნაწილების შეკეთებასა და განახლებას." } },
  # { icon: 'rehab', name: { en: "Youth Services", ka: "სერვისები ახალგაზრდებისათვის" }, description: { en: "Services offering specialized support and assistance to Youth with all types of physical and/or intellectual disabilities", ka: "სპეციალური სერვისები,რომელიც მიმართულია ყველა ტიპის ფიზიკური და გონებრივი შეზღუდვის მქონე ახალგაზრდის მხარდასაჭერად." } },
  # { icon: 'social', name: { en: "Sight, Speech and Hearing", ka: "მხედველობა, მეტყველება და სმენა" }, description: { en: "Services with specific resources, specialized in supporting, training and/or providing medical care for individuals with sight, speech and hearing impairments.", ka: "სპეციალური სერვისები, რომელიც უზრუნველყოფს ტრენინგებსა და სამედიცინო დახმარებას იმ პირებისათვის, ვისაც აქვს მხედველობის, მეტყველების და სმენის პრობლემები." } }
# ]

# load from csv file
# column order:
# 0 - en name
# 1 - en desc
# 2 - ka name
# 3 - ka desc
# 4 - icon
# 5 - for children
# 6 - for adult
# 7 - en parent
services = CSV.read("#{Rails.root}/db/data/services.csv")
created_records = []

puts "ADDING SERVICES"
services.each_with_index {|item, i|
  puts "------------"
  puts "- row #{i}"
  if i > 0
    d = Service.new(
      name_en: item[0].strip,
      description_en: item[1],
      name_ka: item[2].strip,
      description_ka: item[3],
      icon: item[4],
      for_children: item[5] == 'TRUE',
      for_adults: item[6] == 'TRUE',
      position: i+1
    )

    # if this is a child, assign the parent
    if item[7].present?
      parent = created_records.select{|x| x.name_en == item[7].strip}.first
      if parent
        puts "-- adding parent #{parent.id}"
        d.parent_id = parent.id
      else
        puts "-- COULD NOT FIND PARENT #{item[7]}"
      end
    end

    d.save

    created_records << d
  end
}

Municipality.destroy_all
munis = CSV.read("#{Rails.root}/db/data/municipalities.csv")

puts "ADDING MUNICIPALAITES"
munis.each_with_index {|item, i|
  puts "------------"
  puts "- row #{i}"
  d = Municipality.create(
    name_ka: item[0],
    name_en: item[1]
  )
}


Region.destroy_all
regions = [
  { name: { en: "Abkhazia", ka: "აფხაზეთი" }, center: { en: "Sukhumi", ka: "" } },
  { name: { en: "Adjara", ka: "აჭარა" }, center: { en: "Batumi", ka: "" } },
  { name: { en: "Guria", ka: "გურია" }, center: { en: "Ozurgeti", ka: "" } },
  { name: { en: "Imereti", ka: "იმერეთი" }, center: { en: "Kutaisi", ka: "" } },
  { name: { en: "Kakheti", ka: "კახეთი" }, center: { en: "Telavi", ka: "" } },
  { name: { en: "Kvemo Kartli", ka: "ქვემო ქართლი" }, center: { en: "Rustavi", ka: "" } },
  { name: { en: "Mtskheta-Mtianeti", ka: "მცხეთა-მთიანეთი" }, center: { en: "Mtskheta", ka: "" } },
  { name: { en: "Racha-Lechkhumi and Kvemo Svaneti", ka: "რაჭა-ლეჩხუმი და ქვემო სვანეთი" }, center: { en: "Ambrolauri", ka: "" } },
  { name: { en: "Samegrelo-Zemo Svaneti", ka: "სამეგრელო-ზემო სვანეთი" }, center: { en: "Zugdidi", ka: "" } },
  { name: { en: "Samtskhe-Javakheti", ka: "სამცხე-ჯავახეთი" }, center: { en: "Akhaltsikhe", ka: "" } },
  { name: { en: "Shida Kartli", ka: "შიდა ქართლი" }, center: { en: "Gori", ka: "" } },
  { name: { en: "Tbilisi", ka: "თბილისი" }, center: { en: "Tbilisi", ka: "თბილისი" } }
]

regions.each {|item|
  d = Region.create()
  geocodes = geocodes_from_address("#{item[:center][:en]}, #{item[:name][:en]}")
  coordinate = geocodes.present? ? geocodes : [41.44273, 45.79102]
  I18n.available_locales.each { |locale|
    Globalize.with_locale(locale) do
      d.update_attributes(
        :name => item[:name][locale],
        :center => item[:center][locale],
        :latitude => coordinate[0],
        :longitude => coordinate[1]
        )
    end
  }
}

# tags = [
#   { name: "Physical Rehabilitation" },
#   { name: "Blind guide" },
#   { name: "Massage therapy" },
#   { name: "Physical assessment" },
#   { name: "Psychological assessment" },
#   { name: "Small grants" }
# ]
# Tag.destroy_all
# tags.each {|item|
#   d = Tag.create(item)
# }
  # I18n.available_locales.each { |locale|
  #   Globalize.with_locale(locale) do
  #     d.update_attributes(:name => item[:name][locale])
  #   end
  # }

descr = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."


email = 'application@sheaghe.ge'
if User.where(email: email).count == 0
  puts 'Creating app user and api key'
  #User.where(email: email).destroy
  u = User.new(email: email, password: Devise.friendly_token[0,30], role: 1, confirmed_at: DateTime.now, has_agreed: true)
  u.first_name = 'Application'
  u.save(validate: false)
end

if !Rails.env.production?
  ['user', 'provider', 'admin'].each_with_index {|user, user_i|
    u = User.new({
      first_name: user.capitalize,
      last_name: 'Account',
      email: "feedback#{user_i+1}@test.ge",
      password: 'password',
      confirmed_at: DateTime.now,
      role: user_i,
      has_agreed: true,
      is_service_provider: user != 'user'
    })
    u.save(validate: false)
  }
end


# Provider.destroy_all
# providers = [
#   { name: { en: "Unknown Provider", ka: "Unknown Provider" }, description: { en: "Unknown Provider", ka: "Unknown Provider" } }
# ]

# providers.each {|item|
#   d = Provider.create()
#   I18n.available_locales.each { |locale|
#     Globalize.with_locale(locale) do
#       d.update_attributes(:name => item[:name][locale], :description => item[:description][locale])
#     end
#   }
# }
