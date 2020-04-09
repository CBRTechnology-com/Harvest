var html = 
'<div class="form-row">' + 
'  <div id="card-element">' +
'    <!-- a Stripe Element will be inserted here. -->' +
'  </div>' +
'    <!-- Used to display form errors -->' +
'  <div id="card-errors" role="alert"></div>' +
'</div>'

var control = document.getElementById('controlAddIn');
control.innerHTML = html;

Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlAddInReady', null);
