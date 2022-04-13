// Copyright © 2022 Tokenary. All rights reserved.

import Foundation
import UIKit
import Combine

protocol Reusable {
    func prepareForReuse()
}

class CachingImageView: UIImageView, Reusable {
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    init() {
        super.init(image: nil, highlightedImage: nil)
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func prepareForReuse() {
        image = nil
        alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
}

extension CachingImageView: Configurable {
    typealias ViewModel = String
    
    func configure(with viewModel: String) {
        cancellable = loadImage(for: viewModel).sink { [unowned self] image in self.show(image: image) }
    }
    
    private func show(image: UIImage?) {
        alpha = 0.0
        animator?.stopAnimation(false)
        self.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.alpha = 1.0
            }
        )
    }

    private func loadImage(for identifier: String) -> AnyPublisher<UIImage?, Never> {
        return Just(identifier)
        .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
            let url = URL(string: identifier)!
            return ImageLoader.shared.loadImage(from: url)
        })
        .eraseToAnyPublisher()
    }
}
