---
layout: post
title: Django redirect shortcuts and files
date: 2014-03-22 23:17:34
category: technology
tags: [django, python]
type: code
---

I ran across a very helpful Django shortcut utility today called `redirect` while upgrading a section of code in my webapp for work.

I had used redirects in my Django webapps before, but I had never read the documentation closely enough to recognize that there is one really great feature baked into this method. First, let me give some background on my use case.

I have a form where users can upload a file and assign it a type. That file is first saved to the database, then processed and the contents are displayed on the next form (the webapp is a file import tool with custom field mapping). The issue I was running into was trying to go from a successful file upload to a mapping form for that newly uploaded file. There didn't seem like an easy way to simply "go" to the next form.

In reading the first example on [djangoproject.com][shortcuts], I had a bit of an epiphany. The documentation reads:

> By passing some object [to the redirect method]; that object’s `get_absolute_url()` method will be called to figure out the redirect URL

What this meant for me was that I could simply pass the newly saved file object to the redirect method, and rely on the `get_absolute_url` permalink I had already created to provide the url for my next form.

Here is a brief snippet of code from my project showing how I did this:

{% highlight python linenos=table %}
# models.py
from django.db import models
from django_extensions.db import fields

class CSVFile(models.Model):
    uuid = fields.UUIDField(max_length=36, unique=True)
    file = models.FileField(max_length=100, upload_to='beta')
    recordtype = models.CharField(max_length=100)
    created = models.DateTimeField(auto_now_add=True)

    @models.permalink
    def get_absolute_url(self):
        return ('wizard.views.wizard_beta_mapping', [str(self.uuid)])


# views.py
from django.shortcuts import redirect
from wizard.forms import WizardFormBetaUpload
from wizard.models import CSVFile

def wizard_beta_upload(request):
    if request.POST and request.method == 'POST':
        form = WizardFormBetaUpload(request.POST, request.FILES)

        if form.is_valid():
            c_recordtype = form.cleaned_data['recordtype']
            csvfile = CSVFile(
                file=request.FILES['csvfile'],
                recordtype=c_recordtype
            )
            csvfile.save()
            return redirect(csvfile)
{% endhighlight %}

[shortcuts]: https://docs.djangoproject.com/en/1.4/topics/http/shortcuts/