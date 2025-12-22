require('dotenv').config(); 
const functions = require("firebase-functions");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY); 
//const stripe = require("stripe")("SECRET_KEY");

exports.stripePaymentIntenRequest = functions.https.onRequest(async (req, res) => {
    try {
        let customerId;

        // Search for customer by email
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });

        // If exists, use first customer id, else create new customer
        if(customerList.data.length !== 0){
            customerId = customerList.data[0].id;
        } else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.id;
        }

        // Create ephemeral key linked to customer
        const ephemeralkey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2020-08-27' }
        );

        // Create payment intent
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'usd',
            customer: customerId,
        });

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralkey: ephemeralkey.secret,
            customer: customerId,
            success: true,
        });
    } catch(error) {
        res.status(404).send({ success: false, error: error.message });
    }
});
