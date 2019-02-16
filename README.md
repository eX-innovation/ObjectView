#  Swift4 ObjectView

Display and Edit any Swift Object in TableViews with minimal configuration. Ideal for Configuration views or development

## Getting Started

### Installing

This framework can be easely integrated into your project.
I wont explain here how this can be done...

### Setup

First you've to import the framework

```
import ObjectView
```

### Using example

As an example we display this Configuration below:

```
public class Configuration {
    public var deviceName: String = ""
    public var selected: String = ""

    public var connections: Array<Connection> = [
        Connection("Phoenix", host: "192.168.69.20", port: 80, timeout: 10.5),
        Connection("MacBook", host: "192.168.69.38", port: 80, timeout: 5.5),
        ]

    public class Connection {
        init(_ name: String, host: String, port: Int, timeout: Double) {
            self.name = name

            self.host = host
            self.port = port

            self.timeout = timeout
            }

        var name: String

        var host: String
        var port: Int

        var timeout: Double
        var type: ConnectionType = .SomeType

        enum ConnectionType: PickableEnum {
            case SomeType
            case AnotherType
            case ThridType
            case Example
        }
    }
}
```

```

// Example wont work!!!

var obj = Configuration()

let model = OVControllerModel(
    obj,
    "Configuration",
    sections: [
        OVObjectSectionModel(
            obj,
            cells: [
                OVValueCellModel(obj, \.deviceName, "Name"),
                OVValueCellModel(
                    obj, \.selected, "Selected", subtitle: "select a config",
                    pickerValues: { () -> (Array<String>) in
                        return obj.connections.reduce([String](), { (result, element) -> [String] in
                            var copy = result
                            copy.append(element.name)
                            return copy
                        })
                    }
                )
            ]
        ),

        OVArraySectionModel<Configuration, Configuration.Connection>(
            obj,
            header: "",
            footer: "",
            movable: true, removable: true, keepOne: true,
            //placeholder: ["count":\.connections.count],
            path: \.connections,
            cellFactory: { (row, element) -> (OVCellModelProtocol) in
                return OVValueCellModel(element, \.name, "name")
            },
            objectFactory: { (row) -> (Configuration.Connection) in
                return Configuration.Connection()
            }
            ),

            OVObjectSectionModel(
                obj, cells: [
                    OVActionCellModel("Hello world", action: {
                        Thread.sleep(forTimeInterval: 4)
                        print("Hello World!")
                    })
                ]
            )

    ], // sections
    
    onAppear: {
        print("Appeared")
    }, onDisappear: {
        print("Disappeared")
    }
)

let controller = OVController(model)
```

## License

This project is licensed under the MIT License
