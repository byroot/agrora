var Delegation = Class({
    
    self: {
        
        uid: 0,
        
        generateUid: function() {
            return ++this.uid;
        },
        
        getBehaviors: function() {
            return _(this).chain().
                functions().
                select(function(name) { return name.indexOf('@') !== -1; }).
                map(_(function(name) {
                    var items = _(name.split("@")).map(function(str) { return str.replace(/^(\s+)/, '').replace(/(\s+)$/, ''); });
                    return {
                        handlerName: name,
                        selector: items[1] || '',
                        event: items[0]
                    };
                }).bind(this));
        },
        
        uidOf: function(element) {
            if (_.isUndefined(element.__delegationUid)) {
                element.__delegationUid = [this.generateUid()];
            }
            return element.__delegationUid[0];
        },
        
        instanceOf: function(element) {
            if (!element) return null;
            if (!this.instances) this.instances = {};
            
            var uid = this.uidOf(element);
            if (_.isUndefined(this.instances[uid])) {
                this.instances[uid] = new this(jQuery(element));
            }
            return this.instances[uid];
        },
        
        observe: function(selector) {
            var klass = this;
            jQuery(function($) {
                $selector = $(selector);
                klass.getBehaviors().each(function(behavior) {
                    $selector.delegate(behavior.selector, behavior.event, function() {
                        var observer = $(this).parent(selector)[0];
                        var instance = klass.instanceOf(observer);
                        if (!instance) return null;
                        return instance[behavior.handlerName].apply(instance, arguments);
                    });
                });
            });
        }
        
    },
    
    initialize: function(element) {
        this.element = element;
    }
    
});

// 
// var Foo = Class(Delegation, {
//     count: 0,
//     
//     'click @ a': function() {
//         console.log(this.count++);
//         this.element.after($('form#new_message').clone());
//     }
// })
// 
// Foo.observe('form#new_message');
