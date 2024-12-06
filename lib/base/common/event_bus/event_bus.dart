import 'dart:async';

class EventType<T> {
  String? key;
  T data;

  EventType({this.key, required this.data});

  String? get page {
    if (data is EventWithPage) {
      return (data as EventWithPage).page;
    }
    return null;
  }

  set onPause(bool s) {
    if (data is EventWithPage) {
      (data as EventWithPage).onPause = s;
    }
  }
}

class EventWithPage<T> {
  final String page;
  final T event;
  bool? onPause;

  EventWithPage(this.page, this.event, {this.onPause});
}

typedef ISubscriber<T> = void Function(T event);

class EventBus {
  static EventBus? _instance;
  late final StreamController<EventType> _streamController;
  final Map<String, EventType> _stackEvents = {};

  factory EventBus.defaultBus({bool sync = false}) {
    return _instance ??= EventBus._default(sync: sync);
  }

  factory EventBus.customBus(StreamController<EventType> controller) {
    return _instance ??= EventBus._custom(controller);
  }

  EventBus._default({bool sync = false}) {
    _streamController = StreamController<EventType>.broadcast(sync: sync);
  }

  EventBus._custom(StreamController<EventType> controller) {
    _streamController = controller;
  }

  void post<T>({String? key, required T event, bool sticky = false}) {
    final eventType = EventType<T>(key: key, data: event);
    if (key != null && sticky) {
      _stackEvents[key] = eventType;
    }
    _streamController.sink.add(EventType<T>(key: key, data: event));
  }

  StreamSubscription subscribe<T>({
    String? key,
    required ISubscriber<T> subscriber,
    String? page,
    bool clearStickyEvent = false,
  }) {
    if (_stackEvents.containsKey(key)) {
      final stickEvent = _stackEvents[key];
      if (stickEvent != null && stickEvent.data is T) {
        subscriber(stickEvent.data as T);
        if (clearStickyEvent) {
          _stackEvents.remove(key);
        }
      }
    }
    if (page == null) {
      return filter<T>(key).listen((event) {
        subscriber(event.data);
      });
    } else {
      return registerPage(subscriber: subscriber, page: page, key: key);
    }
  }

  StreamSubscription registerPage<T>({
    String? key,
    required ISubscriber<T> subscriber,
    required String page,
  }) {
    return filter<T>(key).listen((event) {
      if (page == event.page) {
        subscriber(event.data);
      }
    });
  }

  Stream<EventType<T>> filter<T>(String? key) {
    Stream<EventType<T>> stream;
    if (T == dynamic) {
      stream = _streamController.stream as Stream<EventType<T>>;
    } else {
      stream = _streamController.stream
          .where((event) => event.data is T)
          .cast<EventType<T>>();
    }
    if (key != null) {
      stream = stream.where((event) => event.key == key);
    }
    return stream;
  }
}
