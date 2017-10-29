$(document).on('ready page:load', function () {
    Vue.use(VeeValidate);

    //var emailRE = '^([0-9]+)$'
    var emailRE = "^[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,10}$"
    new Vue({
        el: '#app1',
        data: {
            message: { rules: { required: true, regex: emailRE } },
            max: { rules: { required: true, max: 5 } },
            newUser: {
                name: '',
                email: '',
                postcode: ''
            },
            name_blur: false,
            postcodeBlue: false,
            postcodeMaxLength: 7
        },
        computed: {
            validation: function () {
                return {
                    name: !!this.newUser.name.trim(),
                    //email: emailRE.test(this.newUser.email),
                    postcode: !!this.newUser.postcode.trim() && this.newUser.postcode.length == this.postcodeMaxLength
                }
            },
            isValid: function () {
                //this.$validator.validateAll().then(result => {
                //    return result
                //});
                var validation = this.validation;
                return Object.keys(validation).every(function (key) {
                    return validation[key];
                });
            },
            hasError: function() {
                return this.errors.has('email:required')
            }
        },
        methods: {

        }
    })
});


