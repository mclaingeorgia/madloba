


const main_title = 'FAQ'
const prefix = []
const titles = [
  'What is Sheaghe?',
  'How does it work?',
  'How do I use it?',
  'How do I sign up?',
  'Why would I want to sign up?',
  'Can anyone Sign up? What if I don’t live in Georgia?',
  'I am a service provider, how can I get my service to show up on Rehab GE?',
  'I am a service provider, what do I do if my service is already on Rehab GE?',
  'I am trying to register my services, but the button on the home screen is not working. What do I do now?',
  'I am trying to message a service provider, but the message box is not working',
  'What do you mean by “validated” service? How is it different from an “un-validated” service?',
  'I want to Sign Up, but what if I don’t want to give my address or contact details?',
  'There are so many services listed! How do you make sure they are really providing what they claim?',
  'OK, I’ve found the service I need! How can I be sure it is still available?',
  'I sent an Instant message to the service provider. It’s been a long time and I still have no reply from them. What can I do?',
  'What are all the colored markers with icons?',
  'What do the circles with numbers mean on the map?',
  'Is this website only for Georgia? Is it available in any other countries?',
  'Is it only in Georgian and English?',
  'Is Rehab GE only available Online? What if I need to use it and I don’t have an internet connection?',
  'Is there a Rehab GE app?',
  'I want to develop a website like this for my country / region! How do I do it?'
]

const contents = [
  [
    'Rehab GE is a free online database that allows you to search for rehab services in and around your community, city or region within the country of Georgia. The website is based on a map, which uses markers to show the exact location of the services you are searching for. For more information about how this works, see <a href=\\"#block-2\\">here</a>',
  ],
  [
    'You can use Rehab GE to search for any type of rehab service in Georgia. We have a whole database of service providers on the website; each of them registered according to their location, category of service and the types of service they provide. Using the search tool on the home page of Rehab GE, you can search for registered services by name, region, exact address, or by using keywords that describe the service you are looking for. Alternatively, or for a broader search, you can browse the categories of service, all of which are listed on the right hand side of the home page. Once your search results appear on the map, simply click on the marker to learn more about that specific service. From here, you can also follow the link to the Service Provider’s profile page, which gives you more detailed information about the services they provide as well as how to find them. You can also message the service provider directly through Rehab GE by using the instant messaging feature at the bottom of the Service Provider’s Profile page.',

    'If you are a service provider and would like to know more about registering your services on RehabGE, please see <a href=\\"#block-9\\">here</a>'
  ],
  [
    'Rehab GE helps you search for all types of rehabilitation services in the country of Georgia. The key features of the site include the map, the search tool and the list of Categories. From the home page, you can search for services registered on Rehab GE in one of two ways:',
    [
      'numbered',
      'Using the search tool at the top of the page; simply type in the region or a keyword related to the service you are looking for (or both!) and hit enter; OR',
      'By directly clicking a category from the list of service categories listed on the right hand side of the screen'
    ],
    'The services you are looking for should appear on the map as a coloured marker. Click on the markers to find out more about the services and follow the links to the Service Provider’s profile page.',

    'You can use Rehab GE on your computer, tablet or mobile device. For the moment, it’s only available online and with proper Internet connection, but we are working on making it accessible offline too!'
  ],
  [
    'You can sign up by clicking the \\"Sign up or Sign in\\" button on the top left hand side of the home page. From there you need to follow the instructions and fill out the form to create an account. It’s as easy as that!',

    'Click <a href=\\"sign_up\\">here</a> if you want to be automatically redirected to the Sign Up page.'
  ],
  [
    'Signing up gives you access to some additional features of Rehab GE that allow you to:',
    [
      'Send instant messages to registered service providers',
      'Save a list of Favorite services, so you don’t have to search for them every time',
      'If you are a service provider you will be able to update and edit your service profile as well as register additional services on the site at any time'
    ],
    'By signing up we know that you are a human being! Every profile opened helps us get an idea of what you like and don’t like about Rehab GE so we can improve the site and services to better suit your needs.'
  ],
  [
    'Sure!',

    'Rehab GE is completely free and open source. As long as you have an internet connection and a computer, tablet or mobile device, you are welcome to sign up – even if you don’t live in Georgia. If you live outside Georgia and would like to see a website like this in your own country or Region, see <a href=\\"#todo\\">here[TODO]</a> for more information.'
  ],
  [
    'If you are a service provider and your service is not already registered on Rehab GE you will need to Sign up <a href=\\"sign_up\\">here</a> before you can register your service. Be sure to indicate that you are a service provider when you Sign up to receive further instructions about registering services.',

    'If you are already signed up, simply press the Register Services button on the right hand side of the home page and follow the instructions on the Registration.',

    'Be aware that we review every single registration to make sure they are accurate and real. This takes time, usually around two weeks, so please be patient! We will contact you to let you know if your registration is successful – that means people will be able to search for you on Rehab GE.'
  ],
  [
    'Congratulations! This means your service was pre-registered on Rehab GE, making it more accessible to a greater number of Georgians searching for rehabilitation services.',

    'As a pre-registered service provider, you would have been contacted by the Rehab GE team and given written and / or verbal consent to having your service registered on the site. To complete the full validation of your service, you will need to <a href=\\"sign_up\\">Sign Up</a> and open an account. Once your account is activated, you can link the service to your personal account by clicking the link on the service information page. Activating the account will enable you to edit and update your personal profile as well as the information about your service. It will also turn on the instant messaging function, so that other registered users will be able to get in touch with you directly through the website.',

    'If you would like to be automatically re-directed to the Sign Up page, please click <a href=\\"sign_up\\">here</a>. If you still need more information or are not sure why your service is registered on Rehab GE, please <a href=\\"#todo\\">Contact Us[TODO]</a>.'
  ],
  [
    'The register services function is only available to registered users.',

    'You will need to <a href=\\"sign_up\\">Sign Up</a> and open an account with us before you can register your service. If you are already registered, make sure you are signed in, and then try the Register Services button again from the home page. If the button is still not working or the links appear to be broken, please <a href=\\"#todo\\">Contact Us[TODO]</a> and let us know what’s going on. Unfortunately, things go wrong from time to time – we apologize for any inconvenience and will do our best to fix the problem as soon as possible!'
  ],
  [
    'The Instant messaging feature is only available to registered users.',

    'You will need to <a href=\\"sign_up\\">Sign Up</a> and open an account with us before you can message service providers through the website. If you are already registered, make sure you are signed in, and then try sending your message again.',

    'For some services, the message box will be blocked indefinitely. This means the service provider has not validated their account yet or that they prefer to have users contact them by phone or an alternate email. Sometimes it is because they simply do not have an email address. In these cases, you can try calling the provider or visiting them in person. If you are still unsure, you can <a href=\\"#todo\\">Contact Us[TODO]</a> to check if they are validated or not.'
  ],
  [
    'A “validated” service is one that has been reviewed by Rehab GE and is linked to a registered user on the site. Because they are linked to a user profile, this means you can message the service provider directly through the website using the Instant message box on the service provider’s information page.',

    'An “un-validated” service has also been reviewed by Rehab GE to make sure it is real before being added to the database, but the service provider does not have a profile on Rehab GE. This means you cannot message them instantly through the website, but you can still get in touch by calling the phone number or visiting them in person. In some cases, a different email address may be provided on the service provider page so you can try sending an email the traditional way.'
  ],
  [
    'No problem!',

    'Just leave these sections empty when you are filling out the profile page. You will still need to provide a working email address in order to sign up, but this is so we can make sure you are a real person using the website. We will not use your email address to send spam or any other promotional information, ever. Please read our <a href=\\"privacy_policy\\">Privacy Policy</a> if you want to know more about it.',

    'If you are a service provider, you are also free to leave the contact details empty, but remember that the more contact information you provide, the easier it will be for people to find you. We understand that you may not want people to email your personal account, which is why we recommend using a company email address, or opening a new email account that you can use on Rehab GE.'
  ],
  [
    'All services and service providers are reviewed by the Rehab GE team before you are able to search for them on the website. This means we have called, visited or checked the service through someone else to make sure they are real and actively providing the services they say they are. Making sure the information stays accurate and up to date is a little bit trickier, but we have a system in place to make sure the service providers are active in updating their information page on a regular basis.',

    'If you see a service provider on Rehab GE that you think is giving the wrong information about their services or is no longer operational, please <a href=\\"#todo\\">Contact Us[TODO]</a> and let us know all about it. We will personally follow up every claim.'
  ],
  [
    'The best way to make sure is to contact them! You can do this by calling them, sending them an email or sending an instant message through the website. If it is convenient for you, you can even go there in person.',

    'As much as we try to make sure that all the services registered on Rehab GE are still functioning and up to date, we acknowledge that some might still slip through the cracks. We also cannot guarantee the quality of the services they provide. If you see a service provider on Rehab GE that you think is giving the wrong information about their services or is no longer operational, please <a href=\\"#todo\\">Contact Us[TODO]</a> and let us know all about it. We will personally follow up every claim.'
  ],
  [
    'Unfortunately there’s not a whole lot you can do. The instant message is sent to an email account, so it might be that the service provider is away or unable to reply at this time. Some service providers offer a different email address and telephone number on their information page. If you haven’t already, we suggest you give them a try.  If there is still no response, or you have a feeling that the service is no longer operational, please let us know <a href=\\"#todo\\">here[TODO]</a>.'
  ],
  [
    'The colored markers indicate the category of service that is associated with the registered services. You will notice that some service providers are linked to more than one category – this is so that they are easier to search for. The colors themselves have no particular meaning, but the symbols do relate to the category in some way so that they are easily recognizable.',

    'If you have any feedback or questions about the markers or the colors we have chosen, please <a href=\\"#todo\\">Contact Us[TODO]</a> and let us know what you think.'
  ],
  [
    'These are the number of services related to your search category that are available in a single location. We have condensed them to make it more visually appealing. Click on the number to zoom in and find out more about the services available in that location.'
  ],
  [
    'At the moment, Rehab GE is focused on rehabilitation services available only in the country of Georgia. This is reflected in the map on our home screen. Other countries might have similar websites, offering similar services, but we have no association with them.'
  ],
  [
    'Yes, at this time the only languages are Georgian and English'
  ],
  [
    'Yes, at the moment Rehab GE is only available online, but we are working to fix that!',

     'You can use it on your mobile device if you have access to data; however the site might work a bit slower than usual.'
  ],
  [
    'Unfortunately there is no app, yet – we are working on it!'
  ],
  [
    'Great!  You can find all the information you need to start your own version of Rehab GE on Github. Click <a href=\\"#todo\\">here[TODO]</a> to access the information. Feel free to <a href=\\"#todo\\">Contact Us[TODO]</a> for more information about developing your own version of this website.'
  ]
]


// all todo should be fixed

// faq hasNumberPrefix = true
// privacy_policy hasNumberPrefix = false
// terms hasNumberPrefix = true





setTimeout(function () {

  html = ""
  hasNumberPrefix = true
  if(prefix.length) {
    html+="<div class='toggleable-list-prefix'>"
    html+="<div class='header'>" + main_title + "</div>"

    prefix.forEach(function(d) {
      html += "<p>" + d + "</p>"
    })
    html+="</div>"
  }

  html += "<ul class='toggleable-list'>"
  titles.forEach(function(title, title_i) {
    html += "<li>"

    html += "<a name='block-" + (title_i+1) + "'>" + (hasNumberPrefix ? ((title_i+1) + ". ") : '') + title + "<span class='caret'></span></a>"
    html += "<div class='toggleable-list-text'>"
    contents[title_i].forEach(function(content) {
      if (Array.isArray(content)) {
        let numbered = false
        content.forEach(function(list_item, list_item_i) {
          if(list_item_i === 0) {
            if (list_item === 'numbered') {
              html += "<ul class='numbered'>"
              numbered = true
              return
            }
            else {
              html += "<ul>"

            }
          }
          html += "<li><p>" + (numbered ? ((list_item_i) + ". ") : '') + list_item + "</p></li>"

          if (list_item_i === content.length - 1) {
            html += "</ul>"
          }
        })
      }
      else {
        html += "<p>" + content + "</p>"
      }
    })
    html += "</div>"
    html += "</li>"
  })
  html += "</ul>"
  console.log(html)
}, 200)

/*<header></header>
<p></p>
<ul class="toggleable-list">
  <li>
    <a name='what-is-sheaghe'>text<span class='caret'></span></a>
      <div class="toggleable-list-text">
        <p>
        </p>
        <ul><li><p></p></li>
        </ul>
      </div>
    </a>
  </li>
</ul>
*/
