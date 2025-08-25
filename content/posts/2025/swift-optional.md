---
title: 'Optional 생각해보기'
date: 2025-08-17
weight: 4
slug: "swift-optional"
---

https://github.com/swiftlang/swift/blob/main/stdlib/public/core/Optional.swift

## 구현

```swift
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
```

실제 구현은 이렇게 생기진 않았지만 대충 중요하것만 본다면 위와 같이 볼 수 있다.

메모리에 실제 값이 없는 경우, cpu에서 접근 시 런타임에서 크래시가 나서 앱이 죽을 수 있다.

그래서 임의의 Optional enum타입을 생성해서 해당 변수를 한번 감싸서 해당 문제를 해결하였다.

```swift
let num: Optional<Int> = .none
```

이런식으로 값이 없음을 나타낼 수 있으며, swift에서는 위의 문법을 짧게 let num: Int? = nil 로 표현할 수 있도록 하였다.

아마 Optional.none을 표현하는 키워드로 nil을 등록한것이 아닐까 싶다.

``Optional<Wrapped>`` 값은 특수한 방식으로 내부의 Wrapped값을 추출할 수 있다.

1. if let value = optionalValue
2. guard let value = optionalValue else { return }

위의 두 가지 방식은 

애플에서 내부구현으로 .some(Wrapped)의 연관값을 쉽게 꺼내서 쓸 수 있도록 하였을 것이다.

아래와 같이 생각하면 좋을 것 같다.

```swift
let num: Int? = 3

switch num {
case .none:
    print("nil입니다.")
case .some(let value):
    print("\(value)가 있습니다.")
}
->
if case .some(let value) = num {
    ...
}
->
if case let .some(value) = num {
    ...
}
->
if case let value = num {
    ...
}
```

### map

Optional은 enum 값이어서 extension을 추가할 수 있다.

Optional 실제 코드를 보다가 map을 하는 코드가 있었는데, 사알짝 이해가 안되어서 적어본다.

```swift
extension Optional {
    func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U? {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return .some(try transform(value))
        }
    }
}

let num: Optional<Int> = .some(3)
let mappedNum = num.map { $0 * 2 }

print(mappedNum)
```

대충 이런 식의 코드였음(내가 짬)
저 코드를 짜기 위한 생각의 흐름을 예측해보자.

```swift
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

let num1: Optional<Int> = .some(3)
// -> num1의 2배의 값을 구하고 싶다.

var num2 = 0

if case .some(let num) = num1 {
    num2 = num * 2
}

print(num2)
```

num1의 두 배의 값을 구하고 싶다. 그럼 if case문으로 연관값을 벗겨내고 원하는 값(두 배인 6)을 얻을 수 있을것이다.
그런데 저 벗겨내는 작업이 너무 번거롭고 코드의 수도 많다.
그래서 기존의 map이라는 함수를 Optional에도 추가하고 싶다.
입력 ``Optional<Wrapped>``에 대해서 새로운 타입 U로 변환해야 한다.
출력은 여전히 ``Optional<U>``로 유지해야 한다. 
그래서 해당 함수의 반환 타입은 ``Optional<U>``가 되어야 한다.

### 예외 처리
만약 변환 과정에서 오류가 발생할 수도 있다면?
변환 실패까지 고려해서 transform클로저가 예외를 던질 수 있도록 해야 한다.
그래서 throws를 붙여서 예외를 던질 수 있도록 해야 한다.
(Wrapped) throws → U
이렇게 되면 map 자체도 에러를 던질 수 있는 상태여야 한다.
그래서 transform이 throws 일 때 map도 throws가 되어야 한다.

``func map<U>(_ transform: (Wrapped) throws → U) rethrows → U?``

### 결과
```swift
extension Optional {
    func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U? {
        switch self {
        case .none:
            return .none
        case .some(let wrapped):
            return .some(try transform(wrapped))
        }
    }
}
```

## 옵셔널 패턴

옵셔널 타입인 경우에 값을 벗겨낼때 편하게 벗겨내기 위해서 추가된 기능이다.

### 기존
```swift
let num: Int? = 3

if case .some(let x) = num {
    print("x")
}
// or

if case let .some(x) = num {
    print("x")
}
```

### 적용
```swift
let num: Int? = 3

if case let x? = num {
    print("x")
}
```

기존의 코드는 굉장히 번거롭다. 그래서 .some(x)를 x?로 간단하게 표기하는 기능을 추가했다.
