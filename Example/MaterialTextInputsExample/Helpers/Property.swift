//
//  Property.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 04.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

class Property<Type> {
    
    var value: Type? { get { return nil } set {} }
    
}

class PropertyWrapper<Object, Type>: Property<Type> {
    
    typealias Path = WritableKeyPath<Object, Type>
    
    private let wrapper: () -> Object?
    private let keyPath: Path
    
    init(keyPath: Path, wrapper: @escaping () -> Object?) {
        self.wrapper = wrapper
        self.keyPath = keyPath
    }
    
    override var value: Type? {
        get {
            return wrapper()?[keyPath: keyPath]
        }
        set {
            guard let newValue = newValue else { return }
            var object = wrapper()
            object?[keyPath: keyPath] = newValue
        }
    }
    
}
