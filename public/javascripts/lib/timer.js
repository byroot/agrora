var Timer = Class({
    
    self: {
        
        options: {
            period: 1000,
            event: "timer:tick"
        }
        
    },
    
    initialize: function(selector, options) {
        this.options = _.extend(this.cls.options, options);
        this.selector = selector;
    },
    
    start: function() {
        if (!this.enabled) {
            this.enabled = true;
            this.delay();
        }
    },
    
    paused: function(callback) {
        var oldState = this.enabled;
        try{
            this.enabled = false;
            callback();
        } finally {
            this.enabled = oldState;
        }
    },
    
    stop: function() {
        this.enabled = false;
        clearTimeout(this.timeout);
        this.timeout = null;
    },
    
    fire: function() {
        if (this.enabled) {
            this.selector.trigger(this.options.event, this);
            this.delay();
        }
    },
    
    delay: function() {
        this.timeout = setTimeout(this.fire, this.options.period);
    }
    
});
