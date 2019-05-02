var PayolaCreditCardSubscriptionForm = {
    initialize: function() {
        $(document).off('submit.payola-credit-card-subscription-form').on(
            'submit.payola-credit-card-subscription-form', '.payola-credit-card-subscription-form',
            function() {
                return PayolaCreditCardSubscriptionForm.handleSubmit($(this));
            }
        );
    },

    handleSubmit: function(form) {
        if (!PayolaCreditCardSubscriptionForm.validateForm(form)) {
            return false;
        }

        $(form).find(':submit').prop('disabled', true);
        $('.payola-spinner').show();
        Stripe.card.createToken(form, function(status, response) {
            PayolaCreditCardSubscriptionForm.stripeResponseHandler(form, status, response);
        });
        return false;
    },

    validateForm: function(form) {
        var cardNumber = $( "input[data-stripe='number']" ).val();
        if (!Stripe.card.validateCardNumber(cardNumber)) {
            PayolaCreditCardSubscriptionForm.showError(form, 'The card number is not a valid credit card number.');
            return false;
        }

        var expMonth = $("[data-stripe='exp_month']").val();
        var expYear = $("[data-stripe='exp_year']").val();
        if (!Stripe.card.validateExpiry(expMonth, expYear)) {
            PayolaCreditCardSubscriptionForm.showError(form, "Your card's expiration month/year is invalid.");
            return false;
        }

        var cvc = $( "input[data-stripe='cvc']" ).val();
        if(!Stripe.card.validateCVC(cvc)) {
            PayolaCreditCardSubscriptionForm.showError(form, "Your card's security code is invalid.");
            return false;
        }

        return true;
    },

    stripeResponseHandler: function(form, status, response) {
        if (response.error) {
            PayolaCreditCardSubscriptionForm.showError(form, response.error.message);
        } else {
            var action = $(form).attr('action');

            form.append($('<input type="hidden" name="stripeToken">').val(response.id));
            form.append(PayolaCreditCardSubscriptionForm.authenticityTokenInput());
            $.ajax({
                type: "PUT",
                url: action,
                data: form.serialize(),
                success: function(data) { },
                error: function(data) { PayolaCreditCardSubscriptionForm.showError(form, jQuery.parseJSON(data.responseText).error); }
            });
        }
    },

/*    poll: function(form, num_retries_left, guid, base_path) {
        if (num_retries_left === 0) {
            PayolaCreditCardSubscriptionForm.showError(form, "This seems to be taking too long. Please contact support and give them transaction ID: " + guid);
        }
        var handler = function(data) {
            if (data.status === "active") {
                $('#update-card-details').hide();
            } else {
                setTimeout(function() { PayolaCreditCardSubscriptionForm.poll(form, num_retries_left - 1, guid, base_path); }, 500);
            }
        };
        var errorHandler = function(jqXHR){
            PayolaCreditCardSubscriptionForm.showError(form, jQuery.parseJSON(jqXHR.responseText).error);
        };

        $.ajax({
            type: 'GET',
            dataType: 'json',
            url: base_path + '/subscription_status/' + guid,
            success: handler,
            error: errorHandler
        });
    },
*/
    showError: function(form, message) {
        $('.payola-spinner').hide();
        $(form).find(':submit')
               .prop('disabled', false)
               .trigger('error', message);

        var error_selector = form.data('payola-error-selector');
        if (error_selector) {
            $(error_selector).text(message);
            $(error_selector).show();
        } else {
            form.find('.payola-payment-error').text(message);
            form.find('.payola-payment-error').show();
        }
    },

    authenticityTokenInput: function() {
        return $('<input type="hidden" name="authenticity_token"></input>').val($('meta[name="csrf-token"]').attr("content"));
    }
};

PayolaCreditCardSubscriptionForm.initialize();
