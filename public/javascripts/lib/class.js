// Very simple Ruby & Python inspired class implementation.

function Class () {
    var bases = _.toArray(arguments).reverse();
    var klass = _.first(bases);
    
    // Handle class methods
    if (klass.self) {
        klass = _.extend(klass, klass.self);
        delete klass.self;
    }
    
    // Constructor
    function Class() {
        var self = _.extend({}, klass);
        _.bindAll(self);
        self.cls = Class;
        if (_.isFunction(self.initialize)) self.initialize.apply(self, arguments);
        return self;
    }
    
    
    // Build inheritance
    klass = _.extend.apply(null, [Class].concat(bases));
    return klass;
}
