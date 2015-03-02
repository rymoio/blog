---
layout: post
title: Integrating the Ace editor into your project
published: True
category: technology
tags: [javascript, chrome extension]
type: code
---

I thought I'd write a quick post documenting my experiences (and frustrations) integrating the [Ace][ace] editor from Cloud9 into my Google Chrome extension.

> TL; DR
>
> View the source for my [nsoa-console][console] project on GitHub to see how I implemented custom keywords, custom snippets, and custom auto-complete.

<img src="https://raw.githubusercontent.com/23maverick23/nsoa-console/master/nsoa_console.png" alt="nsoa-console screenshot" class="img-responsive">

I'm going to break this post into multiple parts to make it easier to consume (and in case you only care about implementing certain Ace editor features into your project).

### Custom mode

Ace ships with a relatively large list of standard modes (languages and syntaxes) which is great when you're working with a standard language. In my case, I was working with a custom syntax used at my place of employment that roughly looks like XML (it has some SQL-like syntax as well, which is why I couldn't just use XML by itself).

In order to implement things like code folding, comments, syntax highlighting, etc., I needed to write my own custom mode file that could be used in the Ace editor. Rather than start from scratch, I cloned the Ace source and modified the `mode-xml.js` file (Note: the users of my extension will only ever need this one mode, so overwriting the existing XML mode worked well).

Coming from Sublime Text, where creating syntaxes is as simple as defining some regexp in a YAML or JSON file, creating Ace syntax rules was relatively convoluted. The documentation I was able to find was sparse, so I did my best at reading through the existing source code and built out some simple highlight rules.

{% highlight javascript linenos %}
nsoa_fields: [{
    token: 'keyword.xml',
    regex: 'OA_(FIELDS(|_(SORT|GROUP)_BY|_INITIAL_ONLY)|CUSTOM(_FIELDS(|_INITIAL_ONLY)))(?=\\s)',
}, {
    token: 'keyword.xml',
    regex: 'NS_(FIELDS|CUSTOM_FIELDS(|_FROM_SO_INVOICE_(HEADER|LINE_ITEM)))(?=\\s)'
}],

nsoa_lookup: [{
    token:
    [
        'variable.parameter.xml',
        'text.xml',
        'variable.parameter.xml',
        'text.xml',
        'variable.parameter.xml',
        'text.xml',
        'variable.parameter.xml',
        'text.xml'
    ],
    regex: '(lookup=)(\\w+)(:lookup_table=)(\\w+)(:lookup_by=)(\\w+)(:lookup_return=)(\\w+)'
}],
{% endhighlight %}

Once I got the syntax definitions defined, the only other piece that needed to be customized was block comments. In my syntax, comments follow a MySQL format using a hash or pound symbol, rather than the more standard markup comment format of `<!-- // -->`. To do this, a simple code addition at the end of the mode did the trick.

{% highlight javascript linenos %}
// this.blockComment = {start: "<!--", end: "-->"};
this.blockComment = {start: "# ", end: ""};
{% endhighlight %}

### Custom snippets

For implementing code snippets, I ran into a lot of issues. I'm going to chalk this up to lack of knowledge on my part, but I'm also going to say again that the documentation around this piece seemed very sparse - I basically lived on Stack Overflow for a few hours as I researched this.

In the end, I found a few public Gists that implemented custom snippet managers, and I used pieces of those to formulate my snippet support.

The first part of this was to create the custom snippet manager instance which would load and process my snippets at the time of loading the editor.

{% highlight javascript linenos %}
ace.config.loadModule('ace/ext/language_tools', function () {
    editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true
    });

    var snippetManager = ace.require("ace/snippets").snippetManager;
    var config = ace.require("ace/config");

    ace.config.loadModule("ace/snippets/xml", function(m) {
        if (m) {
            snippetManager.files.xml = m;
            m.snippets = snippetManager.parseSnippetFile(m.snippetText);
            var nsoa_snippets = nsoaGetSnippets();
            nsoa_snippets.forEach(function (s) { m.snippets.push(s); });
            snippetManager.register(m.snippets, m.scope);
        }
    });
});
{% endhighlight %}

Once you have this piece implemented, you just need to provide the snippet content. Now, according to the documentation (and the oft-referenced "kitchen sink demo"), you should be able to create a snippet file which has the your desired mode name, and the snippets will be recognized and parsed appropriately. For whatever reason, this would not work for me when using multiple snippets in the file (I could always get the first snippet to load, but nothing after that).

Again, after racking my brain and my keyboard for a while, I decided to provide my snippets in an already parsed format so that they could be passed immediately to the snippet manager from the previous step. The format was a simple array of snippet objects.

{% highlight javascript linenos %}
function nsoaGetSnippets() {
    return [{
        name: "lookup",
        content: "lookup=${1:ns_field}:lookup_table=${2:oa_table}:lookup_by=${3:oa_field}:lookup_return=${4:oa_field}",
        tabTrigger: "lookup"
    },
    {
        name: "dropdown",
        content: "<${1:oa_field} ${2:ns_field}>\n    ${3:ns_value} ${4:oa_value}\n</${1}>\n",
        tabTrigger: "dropdown"
    }];
}
{% endhighlight %}

### Custom auto-complete

The last part of my Ace editor customizations was implementing auto-complete. I wanted 2 important things from this: first - a custom trigger for showing the auto-complete list; second - the ability to add custom keywords to the auto-complete list (this last part being of most importance, since my custom syntax has a long list of custom keywords that are a pain to type each time).

To get this done, I actually had to modify both my custom mode file (again) and my editor file (from above). In my mode file, I needed to add a custom `keywordMapper`. This tells the editor which keywords should be recognized by the auto-complete engine in the `language_tools` extension. The format for this was a simple string list of keywords.

{% highlight javascript linenos %}
var keywordMapper = this.createKeywordMapper({
    "tag" : "OA_CUSOM_FIELDS_INITIAL_ONLY|OA_CUSTOM_FIELDS|OA_FIELDS_INITIAL_ONLY|" +
    "OA_FIELDS|OA_FIELDS_SORT_BY|OA_FIELDS_GROUP_BY|" +
    "NS_PR_TASK_TO_OA_PR_TASK|NS_INVOICE_TO_OA_INVOICE|NS_EXPENSE_REP_TO_OA_EXPENSE_REP|" +
    "NS_CUSTOM_FIELDS_FROM_SO_INVOICE_HEADER|NS_CUSTOM_FIELDS_FROM_SO_INVOICE_LINE_ITEM|" +
    "NS_CUSTOM_FIELDS|NS_FIELDS"
}, "identifier");
{% endhighlight %}

Now that my keywords were defined, I simply wanted to customize the default trigger for showing the auto-complete list. This was done back in my editor file with a simple command and some regexp. In this case, since almost all of my keywords use underscores (see above), I wanted auto-complete to trigger when an underscore was typed and when a left angle bracket was typed.

{% highlight javascript linenos %}
editor.commands.on("afterExec", function(e){
    if (e.command.name == "insertstring" && /^[\<_]$/.test(e.args)) {
        editor.execCommand("startAutocomplete");
    }
});
{% endhighlight %}

So in the end, this took me a fair amount of effort (mostly in doing hours of research to figure out how to do what I needed to do). My hope with this post is that is helps someone who comes across it on a web search - or for me the next time I need to implement this in another project. Happy coding!

[ace]: http://ace.c9.io/
[console]: https://github.com/23maverick23/nsoa-console