---
layout: post
title: Django secret key field
date: 2014-02-08 08:31:29
category: technology
tags: [django]
type: code
---

I recently developed an online form for my company which would accept a CSV file and account credentials for importing that data via our XML API. The purpose of the form was to allow Mac users a method of importing CSV data into our demo database (as our CSV import tool is currently Windows only).

I didn't want to implement a user login mechanism because I didn't want to deal with the provisioning of users, and I also knew that any imports with incorrect login credentials would already fail with `401 authentication` errors. I did, however, want a way to limit invalid form submission attempts (in the event someone came across the link to my form).

My idea was to implement a "secret key" field on the form using a simple password that everyone on my team would know. Nothing super secure or unguessable, but good enough to stop random form POSTs being sent through our XML API.

Here is the code I used to implement a new field type of `SecretKeyField`. As you can see, I simply subclassed the standard `CharField` class found in `django.forms`, and implemented a check for a key (stored in a file called _secrets_).

{% highlight python linenos=table %}
# forms.py
from django import forms
from django.core.exceptions import ValidationError

from secrets import KEYS

class SecretKeyField(forms.CharField):
    """
    Checks the value passed to the field against a secret key value
    and throws a validation error if there is not an exact match. The
    secretkey should be stored in a file named "secrets.py", with a dictionary
    called "KEYS" and a key named "secretkey".

    ex// secrets.py
    KEYS = {
        "secretkey": "abc123",
    }

    """
    def __init__(self, *args, **kwargs):
        super(SecretKeyField, self).__init__(*args, **kwargs)

    def clean(self, *args, **kwargs):
        secretkey = super(SecretKeyField, self).clean(*args, **kwargs)
        if not secretkey == KEYS['secretkey']:
            err = self.error_messages['invalid']
            raise ValidationError(err)

        return secretkey

class MyForm(forms.Form):
    secretkey = SecretKeyField(
        max_length=5,
        required=True,
        error_messages={
            'required': 'A secret key is required!',
            'invalid': 'You have provided an invalid secret key!'
        },
        widget=forms.PasswordInput(
            attrs={
                'class': 'form-control input-lg',
                'id': 'secretkey'
            }
        )
    )
{% endhighlight %}

So far it has done the trick and allows my team to continue using the import form without much additional hassle or negative user experience. Let me know if you've tried this before and have a better or alternate approach.