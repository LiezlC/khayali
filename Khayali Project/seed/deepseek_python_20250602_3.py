def translate_across_domains(self, pattern, source, target):
    # Use ECAI's translator if domains are cultural/abstract
    if source in ['cultural', 'alien_primitives']:
        return self.alien_cognition_layer.translate(pattern, source, target)
    else:  # Fall back to UCP's manual method
        return super().translate_across_domains(pattern, source, target)