controladdin StripeCreditCardControl
{
    HorizontalShrink = true;
    HorizontalStretch = true;
    VerticalShrink = false;
    VerticalStretch = true;

    MinimumHeight = 120;
    RequestedHeight = 120;
    MaximumHeight = 120;

    MinimumWidth = 150;
    RequestedWidth = 300;
    MaximumWidth = 540;

    Scripts = 'https://js.stripe.com/v3/',
              './controladdin/CreditCardControl/Script.js';
    StartupScript = './controladdin/CreditCardControl/StartupScript.js';
    StyleSheets = './controladdin/CreditCardControl/Style.css';

    event ControlAddInReady();
    procedure InitializeCheckOutForm();
    event InputChanged(complete: Boolean);
    procedure CreateStripeToken();
    event StripeTokenCreated(newTokenId: Text);
}