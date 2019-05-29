# SuperButton

[![CI Status](https://img.shields.io/travis/kraigwastlund/SuperButton.svg?style=flat)](https://travis-ci.org/kraigwastlund/SuperButton)
[![Version](https://img.shields.io/cocoapods/v/SuperButton.svg?style=flat)](https://cocoapods.org/pods/SuperButton)
[![License](https://img.shields.io/cocoapods/l/SuperButton.svg?style=flat)](https://cocoapods.org/pods/SuperButton)
[![Platform](https://img.shields.io/cocoapods/p/SuperButton.svg?style=flat)](https://cocoapods.org/pods/SuperButton)

## Example

Motion
:-------------------------:|
![picture](https://raw.githubusercontent.com/KraigWastlund/SuperButton/master/ReadmeResources/example_150_half.gif) |


Three Buttons | Four Buttons | Five Buttons | Six Buttons | Seven Buttons
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://raw.githubusercontent.com/KraigWastlund/SuperButton/master/ReadmeResources/3.png" width="150">  |  <img src="https://raw.githubusercontent.com/KraigWastlund/SuperButton/master/ReadmeResources/4.png" width="150">  |  <img src="https://raw.githubusercontent.com/KraigWastlund/SuperButton/master/ReadmeResources/5.png" width="150">  |  <img src="https://raw.githubusercontent.com/KraigWastlund/SuperButton/master/ReadmeResources/6.png" width="150">  |  <img src="https://raw.githubusercontent.com/KraigWastlund/SuperButton/master/ReadmeResources/7.png" width="150"> 

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS > 8.2
Maximum number of buttons supported = 7

## Installation

SuperButton is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SuperButton'
```

## Usage
```swift
import SuperButton

class ViewController: UIViewController {

    var superButtonView: SuperButtonView!

    @IBOutlet weak var actionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ... create the super button and give the main button the color you'd like
        let mainButtonColor = UIColor(red: 0/255, green: 21/255, blue: 211/255, alpha: 1.0)
        superButtonView = SuperButtonView(nodes: nodes(), mainButtonColor: mainButtonColor)
        setup()
    }

    private func setup() {
        // ... constrain / setup ui elements how you'd like
        // ... you can use frame/storyboard if you'd like
        // ... buttons always have a static width and space out from center
    }

    private func fadeDisplayText(text: String) {
        // ... displays text in a cool way :)
    }

    private func nodes() -> [SuperNodeView] {
        var nodes = [SuperNodeView]()

        // ... note that the main button takes a color and the `node` buttons take an image.

        // ... you can instantiate a node this way:
        nodes.append(SuperNodeView(title: "Node 1", image: #imageLiteral(resourceName: "1"), completion: { [weak self] in self?.fadeDisplayText(text: "Node 1 Triggered") }))

        // ... or like this:
        let node2 = SuperNodeView()
        node2.title = "Node 2"
        node2.image = #imageLiteral(resourceName: "2")
        node2.completion = { [weak self] in self?.fadeDisplayText(text: "Node 2 Triggered") }
        nodes.append(node2)

        // ... add more buttons at your leisure

        return nodes
    }
}
```

## Author

kraigwastlund, kraigwastlund@gmail.com

## License

SuperButton is available under the MIT license. See the LICENSE file for more info.
