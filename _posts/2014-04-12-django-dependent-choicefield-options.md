---
layout: post
title: Django dependent ChoiceField options
date: 2014-04-12 07:53:44
category: technology
tags: [django, python]
type: code
---

On a recent project, I was looking to control the options available in a Django ChoiceField based on another form parameter (passed along with the response object).

The tricky part was that ChoiceFields by default perform their clean method using the _choices_ key set on the field in `forms.py`. Because my choices were going to be very different from each other depening on the field passed to the form, I didn't want to pass all possible choices to the ChoiceField and then use JavaScript to filter/remove them onload.

I did some searching on the interwebs and came across [this blog post][1] that talked about passing an `init` function to your form to essentially add your dependent field on the fly. It also talked about using a function as the `choices` keyword, which allows the list of choices to be determined at each load of the form.

The end result is a really beautiful solution for a problem I'm guessing a number of folks will come across. If you want to review a quick snippet of exactly how I setup my configuration, have a read through the code below. I've sanitized and simplified, but the overall example is highlighted well.

{% highlight python %}
# somefile.json
{
    "key_one": ["", "A", "B", "C", "D"],
    "key_two": ["", "1", "2", "3"],
    "key_three": ["", "a1", "b2", "c3"]
}


# forms.py
try:
    import simplejson as json
except ImportError:
    import json

from django import forms


def getFieldChoices(key_field=None):
    """
    Return a tuple of field choices from a json file.

    """
    with open('somefile.json') as f:
        json_data = json.load(f)
        choices_list = []
        if key_field and key_field in json_data:
            fields = json_data[key_field]
            for field in fields:
                choices_list.append((field, field))
    return tuple(choices_list)


class MyForm(forms.Form):
    def __init__(self, *args, **kwargs):
        self._key_field = kwargs.pop('key_field', None)
        super(MyForm, self).__init__(*args, **kwargs)
        self.fields['my_choice_field'] = forms.ChoiceField(
            choices=getFieldChoices(self._key_field),
            required=False,
            initial='',
            widget=forms.Select()
        )

    # other standard fields go below...
{% endhighlight %}

[1]: http://ilian.i-n-i.org/django-forms-choicefield-with-dynamic-values/