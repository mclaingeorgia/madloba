const main_title = 'Privacy Policy'
const prefix = [
  'At Rehab GE, we are committed to protecting your privacy. Only those authorized as Administrators of the website are able to view and use information relating to all users – registered and unregistered – on the website.'
]


const titles = [
  'Data Collection and information Use',
  'Contact and Instant Messaging service',
  'Confidentiality and Security',
  'Changes to this Privacy Policy',
  'Copyright Complaints',
  'Termination'
]
const contents = [
  [
    [
      'Rehab GE collects information and data about service users and Service providers that have Services Registered with the Rehab GE database.',

      'All data and information that is collected through Rehab GE will be reviewed carefully by the administrators and remain confidential. The ultimate purpose of collecting any data and information about services and service users on this site will be to Improve the services offered through Rehab GE and to Identify the needs in regards to rehabilitative services throughout the country of Georgia.',

      'Any other data collected on the site is purely for the purpose of running the site and will not be shared, rented or sold.',

      'Rehab GE will not rent, sell, or share information about you with other people or non-affiliated companies or organizations.'
    ]
  ],
  [
    [
      'We reserve the right to send Service providers, that have rehabilitative services Registered on the website, certain communications relating to Rehab GE such as service announcements, administrative messages relating to their registration and Information page and any other messages that are considered essential to the functioning of the Rehab GE website without offering you the opportunity to opt out of receiving them',

      'Instant messages sent through the site are one-off events. We will not distribute any email addresses to any third party or associated organization(s) of Rehab GE or use them for anything other than their intended purpose. See <a href=\\"terms_of_use\\">Terms of Use</a> for more information about the purpose of the site and Instant messaging system for Registered Users.',

      'Any messages sent through the Instant messaging feature on Rehab GE are delivered directly to the inbox of the email specified by the Service provider. Rehab GE will not be able to view or edit the Instant messages before the Service Provider receives them. Rehab GE will therefore take no responsibility In the case that any offensive of inappropriate content is sent and received by the Service Provider through this instant messaging service. In such cases, it is the responsibility of the Service provider to contact the Rehab GE team of the breach of Terms of use. In such cases Rehab GE will take whatever action possible to attempt to rectify the situation.',

      'Once received, Service Providers are responsible for responding to the Instant Messages from Service Users within a reasonable timeframe and in an acceptable manner which is in accordance with the Terms of Use of this website and Privacy Policy. In the case that a Service User has received an offensive email or any inappropriate content from the Service Provider they are responsible for immediately notifying the Rehab GE Administrators of the situation.'
    ]
  ],
  [
    'At Rehab GE we limit access to personal information about you to authorized administrators of the website who need to view this information in order to advise and assist in the development of services that will better serve the users and their needs.',
  ],
  [
    'Rehab GE may update this policy from time to time. We are not required to inform of any minor changes, however if there is what we consider to be a significant change to the way in which we treat your personal information, we may inform you by sending an email to the email address that is associated with your Rehab GE account or by placing a prominent notice on our site',
  ],
  [
    'Rehab GE respects copyright, and we prohibit users of our Services from submitting, uploading, posting, or otherwise transmitting any Content on the Services that violates another person’s proprietary rights.',
    'To report anything that you believe may be an infringement of copyright laws, please inform the Administrative Team immediately via email. Contact information can be found on the <a href=\\"#todo\\">Contact Us[TODO]</a> page.'

  ],
  [
    'By Rehab GE: We reserve the right to modify, suspend, or terminate the operation of, or access to, all or any of the Services provided through this website at any time and for any reason. In addition your individual access to, and use of, the Services may be terminated at any time, for any reason by the Rehab GE Administrative Team. In the case that such an event does occur, we will contact you by email to your verified email address that is associated with your Personal Account.',

    'By you: If you wish to terminate this agreement, you may immediately stop accessing or using the Services at any time. The procedure for closing your account is described in <a href=\\"terms_of_use\\">Terms of Use</a>',

    'Automatic upon breach: Your right to access and use the Services offered on Rehab GE terminates automatically upon your breach of any of the <a href=\\"terms_of_use\\">Terms of Use</a>.'
  ]
]




setTimeout(function () {

  html = ""
  hasNumberPrefix = false
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
