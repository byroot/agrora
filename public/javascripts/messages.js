var MessageForm = Class(Delegation, {
    
    getTimer: function() {
        if (!this.timer) this.timer = new Timer(this.getBodyInput());
        return this.timer;
    },
    
    getBodyInput: function() {
        return this.element.find('#message_body');
    },
    
    refreshPreview: function() {
        if (this.hasChanged()) {
            this.getTimer().paused(this.renderPreview);
        }
    },
    
    renderPreview: function() {
        jQuery.post('/message/preview', this.element.serialize(), this.updatePreview);
    },
    
    updatePreview: function(response) {
        $('.preview').html(response);
    },
    
    hasChanged: function() {
        return !_.isUndefined(this.previousBody) & this.previousBody != (this.previousBody = this.getBodyInput().val());
    },
    
    'timer:tick @ #message_body': function(event, timer) {
        this.refreshPreview();
    },
    
    'blur @ #message_body': function(event) {
        this.getTimer().stop();
    },
    
    'focus @ #message_body': function(event) {
        this.getTimer().start();
    }
    
});

MessageForm.observe('#messages-controller.action-new form#new_message');