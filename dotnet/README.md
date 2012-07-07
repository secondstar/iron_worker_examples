We currently support .NET through our "Binary" runtime. This works perfectly fine as all it's doing is executing mono anyways, but the semantics will change slightly when we switch to a native "mono" runtime.

Moral of the story: you can use it now no problem, when native mono is released you will need to change 1 line in your .worker file.
