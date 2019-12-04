// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async' show StreamSubscription;

/// Widgets that handle interaction with asynchronous computations.
///
/// Asynchronous computations are represented by [Future]s and [Stream]s.

//import 'dart:async' show Future, Stream, StreamSubscription;

import 'package:flutter/widgets.dart';

//import 'framework.dart';

// Examples can assume:
// dynamic _lot;
// Future<String> _calculation;

/// Base class for widgets that build themselves based on interaction with
/// a specified [Stream].
///
/// A [SWStreamBuilderBase] is stateful and maintains a summary of the interaction
/// so far. The type of the summary and how it is updated with each interaction
/// is defined by sub-classes.
///
/// Examples of summaries include:
///
/// * the running average of a stream of integers;
/// * the current direction and speed based on a stream of geolocation data;
/// * a graph displaying data points from a stream.
///
/// In general, the summary is the result of a fold computation over the data
/// items and errors received from the stream along with pseudo-events
/// representing termination or change of stream. The initial summary is
/// specified by sub-classes by overriding [initial]. The summary updates on
/// receipt of stream data and errors are specified by overriding [afterData] and
/// [afterError], respectively. If needed, the summary may be updated on stream
/// termination by overriding [afterDone]. Finally, the summary may be updated
/// on change of stream by overriding [afterDisconnected] and [afterConnected].
///
/// `T` is the type of stream events.
///
/// `S` is the type of interaction summary.
///
/// See also:
///
///  * [SWStreamBuilder], which is specialized for the case where only the most
///    recent interaction is needed for widget building.
abstract class SWStreamBuilderBase<T, S> extends StatefulWidget {
  /// Creates a [SWStreamBuilderBase] connected to the specified [stream].
  const SWStreamBuilderBase({ Key key, this.stream }) : super(key: key);

  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null. When changed, the current summary is updated using
  /// [afterDisconnected], if the previous stream was not null, followed by
  /// [afterConnected], if the new stream is not null.
  final Stream<T> stream;

  /// Returns the initial summary of stream interaction, typically representing
  /// the fact that no interaction has happened at all.
  ///
  /// Sub-classes must override this method to provide the initial value for
  /// the fold computation.
  S initial();

  /// Returns an updated version of the [current] summary reflecting that we
  /// are now connected to a stream.
  ///
  /// The default implementation returns [current] as is.
  S afterConnected(S current) => current;

  /// Returns an updated version of the [current] summary following a data event.
  ///
  /// Sub-classes must override this method to specify how the current summary
  /// is combined with the new data item in the fold computation.
  S afterData(S current, T data);

  /// Returns an updated version of the [current] summary following an error.
  ///
  /// The default implementation returns [current] as is.
  S afterError(S current, Object error) => current;

  /// Returns an updated version of the [current] summary following stream
  /// termination.
  ///
  /// The default implementation returns [current] as is.
  S afterDone(S current) => current;

  /// Returns an updated version of the [current] summary reflecting that we
  /// are no longer connected to a stream.
  ///
  /// The default implementation returns [current] as is.
  S afterDisconnected(S current) => current;

  /// Returns a Widget based on the [currentSummary].
  Widget build(BuildContext context, S currentSummary);

  @override
  State<SWStreamBuilderBase<T, S>> createState() => _SWStreamBuilderBaseState<T, S>();
}

/// State for [SWStreamBuilderBase].
class _SWStreamBuilderBaseState<T, S> extends State<SWStreamBuilderBase<T, S>> {
  StreamSubscription<T> _subscription;
  S _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.initial();
    _subscribe();
  }

  @override
  void didUpdateWidget(SWStreamBuilderBase<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = widget.afterDisconnected(_summary);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _summary);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream.listen((T data) {
        setState(() {
          _summary = widget.afterData(_summary, data);
        });
      }, onError: (Object error) {
        setState(() {
          _summary = widget.afterError(_summary, error);
        });
      }, onDone: () {
        setState(() {
          _summary = widget.afterDone(_summary);
        });
      });
      _summary = widget.afterConnected(_summary);
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}

/// The state of connection to an asynchronous computation.
///
/// See also:
///
///  * [SWAsyncSnapshot], which augments a connection state with information
///    received from the asynchronous computation.
enum SWConnectionState {
  /// Not currently connected to any asynchronous computation.
  ///
  /// For example, a [SWFutureBuilder] whose [SWFutureBuilder.future] is null.
  none,

  /// Connected to an asynchronous computation and awaiting interaction.
  waiting,

  /// Connected to an active asynchronous computation.
  ///
  /// For example, a [Stream] that has returned at least one value, but is not
  /// yet done.
  active,

  /// Connected to a terminated asynchronous computation.
  done,
}

/// Immutable representation of the most recent interaction with an asynchronous
/// computation.
///
/// See also:
///
///  * [SWStreamBuilder], which builds itself based on a snapshot from interacting
///    with a [Stream].
///  * [SWFutureBuilder], which builds itself based on a snapshot from interacting
///    with a [Future].
@immutable
class SWAsyncSnapshot<T> {
  /// Creates an [SWAsyncSnapshot] with the specified [connectionState],
  /// and optionally either [data] or [error] (but not both).
  SWAsyncSnapshot._(this.connectionState, this.data, this.error,this.currentTime)
      : assert(connectionState != null),
        assert(!(data != null && error != null));

  /// Creates an [SWAsyncSnapshot] in [SWConnectionState.none] with null data and error.
  SWAsyncSnapshot.nothing() : this._(SWConnectionState.none, null, null, DateTime.now().millisecondsSinceEpoch);

  /// Creates an [SWAsyncSnapshot] in the specified [state] and with the specified [data].
  SWAsyncSnapshot.withData(SWConnectionState state, T data) : this._(state, data, null, DateTime.now().millisecondsSinceEpoch);

  /// Creates an [SWAsyncSnapshot] in the specified [state] and with the specified [error].
  SWAsyncSnapshot.withError(SWConnectionState state, Object error) : this._(state, null, error, DateTime.now().millisecondsSinceEpoch);

  /// Current state of connection to the asynchronous computation.
  final SWConnectionState connectionState;

  /// The latest data received by the asynchronous computation.
  ///
  /// If this is non-null, [hasData] will be true.
  ///
  /// If [error] is not null, this will be null. See [hasError].
  ///
  /// If the asynchronous computation has never returned a value, this may be
  /// set to an initial data value specified by the relevant widget. See
  /// [SWFutureBuilder.initialData] and [SWStreamBuilder.initialData].
  final T data;
  
  final int currentTime;

  /// Returns latest data received, failing if there is no data.
  ///
  /// Throws [error], if [hasError]. Throws [StateError], if neither [hasData]
  /// nor [hasError].
  T get requireData {
    if (hasData)
      return data;
    if (hasError)
      throw error;
    throw StateError('Snapshot has neither data nor error');
  }

  /// The latest error object received by the asynchronous computation.
  ///
  /// If this is non-null, [hasError] will be true.
  ///
  /// If [data] is not null, this will be null.
  final Object error;

  /// Returns a snapshot like this one, but in the specified [state].
  ///
  /// The [data] and [error] fields persist unmodified, even if the new state is
  /// [SWConnectionState.none].
  SWAsyncSnapshot<T> inState(SWConnectionState state) => SWAsyncSnapshot<T>._(state, data, error, DateTime.now().millisecondsSinceEpoch);

  /// Returns whether this snapshot contains a non-null [data] value.
  ///
  /// This can be false even when the asynchronous computation has completed
  /// successfully, if the computation did not return a non-null value. For
  /// example, a [Future<void>] will complete with the null value even if it
  /// completes successfully.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  ///
  /// This is always true if the asynchronous computation's last result was
  /// failure.
  bool get hasError => error != null;

  @override
  String toString() => '$runtimeType($connectionState, $data, $error)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (other is! SWAsyncSnapshot<T>)
      return false;
    final SWAsyncSnapshot<T> typedOther = other;
    return connectionState == typedOther.connectionState
        && data == typedOther.data
        && currentTime == typedOther.currentTime
        && error == typedOther.error;
  }

  @override
  int get hashCode => hashValues(connectionState, data, error);
}

/// Signature for strategies that build widgets based on asynchronous
/// interaction.
///
/// See also:
///
///  * [SWStreamBuilder], which delegates to an [AsyncWidgetBuilder] to build
///    itself based on a snapshot from interacting with a [Stream].
///  * [SWFutureBuilder], which delegates to an [AsyncWidgetBuilder] to build
///    itself based on a snapshot from interacting with a [Future].
typedef AsyncWidgetBuilder<T> = Widget Function(BuildContext context, SWAsyncSnapshot<T> snapshot);

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=MkKEWHfy99Y}
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
///
/// As an example, when interacting with a stream producing the integers
/// 0 through 9, the [builder] may be called with any ordered sub-sequence
/// of the following snapshots that includes the last one (the one with
/// WConnectionState.done):
///
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.waiting, null)`
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.active, 0)`
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.active, 1)`
/// * ...
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.active, 9)`
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.done, 9)`
///
/// The actual sequence of invocations of the [builder] depends on the relative
/// timing of events produced by the stream and the build rate of the Flutter
/// pipeline.
///
/// Changing the [SWStreamBuilder] configuration to another stream during event
/// generation introduces snapshot pairs of the form:
///
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.none, 5)`
/// * `new WAsyncSnapshot<int>.withData(WConnectionState.waiting, 5)`
///
/// The latter will be produced only when the new stream is non-null, and the
/// former only when the old stream is non-null.
///
/// The stream may produce errors, resulting in snapshots of the form:
///
/// * `new WAsyncSnapshot<int>.withError(WConnectionState.active, 'some error')`
///
/// The data and error fields of snapshots produced are only changed when the
/// state is `WConnectionState.active`.
///
/// The initial snapshot data can be controlled by specifying [initialData].
/// This should be used to ensure that the first frame has the expected value,
/// as the builder will always be called before the stream listener has a chance
/// to be processed.
///
/// {@tool sample}
///
/// This sample shows a [SWStreamBuilder] configuring a text label to show the
/// latest bid received for a lot in an auction. Assume the `_lot` field is
/// set by a selector elsewhere in the UI.
///
/// ```dart
/// WStreamBuilder<int>(
///   stream: _lot?.bids, // a Stream<int> or null
///   builder: (BuildContext context, WAsyncSnapshot<int> snapshot) {
///     if (snapshot.hasError)
///       return Text('Error: ${snapshot.error}');
///     switch (snapshot.connectionState) {
///       case WConnectionState.none: return Text('Select lot');
///       case WConnectionState.waiting: return Text('Awaiting bids...');
///       case WConnectionState.active: return Text('\$${snapshot.data}');
///       case WConnectionState.done: return Text('\$${snapshot.data} (closed)');
///     }
///     return null; // unreachable
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ValueListenableBuilder], which wraps a [ValueListenable] instead of a
///    [Stream].
///  * [SWStreamBuilderBase], which supports widget building based on a computation
///    that spans all interactions made with the stream.
// TODO(ianh): remove unreachable code above once https://github.com/dart-lang/linter/issues/1139 is fixed
class SWStreamBuilder<T> extends SWStreamBuilderBase<T, SWAsyncSnapshot<T>> {
  /// Creates a new [SWStreamBuilder] that builds itself based on the latest
  /// snapshot of interaction with the specified [stream] and whose build
  /// strategy is given by [builder].
  ///
  /// The [initialData] is used to create the initial snapshot.
  ///
  /// The [builder] must not be null.
  const SWStreamBuilder({
    Key key,
    this.initialData,
    Stream<T> stream,
    @required this.builder,
  }) : assert(builder != null),
        super(key: key, stream: stream);

  /// The build strategy currently used by this builder.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the initial snapshot.
  ///
  /// Providing this value (presumably obtained synchronously somehow when the
  /// [Stream] was created) ensures that the first frame will show useful data.
  /// Otherwise, the first frame will be built with the value null, regardless
  /// of whether a value is available on the stream: since streams are
  /// asynchronous, no events from the stream can be obtained before the initial
  /// build.
  final T initialData;

  @override
  SWAsyncSnapshot<T> initial() => SWAsyncSnapshot<T>.withData(SWConnectionState.none, initialData);

  @override
  SWAsyncSnapshot<T> afterConnected(SWAsyncSnapshot<T> current) => current.inState(SWConnectionState.waiting);

  @override
  SWAsyncSnapshot<T> afterData(SWAsyncSnapshot<T> current, T data) {
    return SWAsyncSnapshot<T>.withData(SWConnectionState.active, data);
  }

  @override
  SWAsyncSnapshot<T> afterError(SWAsyncSnapshot<T> current, Object error) {
    return SWAsyncSnapshot<T>.withError(SWConnectionState.active, error);
  }

  @override
  SWAsyncSnapshot<T> afterDone(SWAsyncSnapshot<T> current) => current.inState(SWConnectionState.done);

  @override
  SWAsyncSnapshot<T> afterDisconnected(SWAsyncSnapshot<T> current) => current.inState(SWConnectionState.none);

  @override
  Widget build(BuildContext context, SWAsyncSnapshot<T> currentSummary) => builder(context, currentSummary);
}

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Future].
///
/// The [future] must have been obtained earlier, e.g. during [State.initState],
/// [State.didUpdateConfig], or [State.didChangeDependencies]. It must not be
/// created during the [State.build] or [StatelessWidget.build] method call when
/// constructing the [SWFutureBuilder]. If the [future] is created at the same
/// time as the [SWFutureBuilder], then every time the [SWFutureBuilder]'s parent is
/// rebuilt, the asynchronous task will be restarted.
///
/// A general guideline is to assume that every `build` method could get called
/// every frame, and to treat omitted calls as an optimization.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=ek8ZPdWj4Qo}
///
/// ## Timing
///
/// Widget rebuilding is scheduled by the completion of the future, using
/// [State.setState], but is otherwise decoupled from the timing of the future.
/// The [builder] callback is called at the discretion of the Flutter pipeline, and
/// will thus receive a timing-dependent sub-sequence of the snapshots that
/// represent the interaction with the future.
///
/// A side-effect of this is that providing a new but already-completed future
/// to a [SWFutureBuilder] will result in a single frame in the
/// [SWConnectionState.waiting] state. This is because there is no way to
/// synchronously determine that a [Future] has already completed.
///
/// ## Builder contract
///
/// For a future that completes successfully with data, assuming [initialData]
/// is null, the [builder] will be called with either both or only the latter of
/// the following snapshots:
///
/// * `new WAsyncSnapshot<String>.withData(WConnectionState.waiting, null)`
/// * `new WAsyncSnapshot<String>.withData(WConnectionState.done, 'some data')`
///
/// If that same future instead completed with an error, the [builder] would be
/// called with either both or only the latter of:
///
/// * `new WAsyncSnapshot<String>.withData(WConnectionState.waiting, null)`
/// * `new WAsyncSnapshot<String>.withError(WConnectionState.done, 'some error')`
///
/// The initial snapshot data can be controlled by specifying [initialData]. You
/// would use this facility to ensure that if the [builder] is invoked before
/// the future completes, the snapshot carries data of your choice rather than
/// the default null value.
///
/// The data and error fields of the snapshot change only as the connection
/// state field transitions from `waiting` to `done`, and they will be retained
/// when changing the [SWFutureBuilder] configuration to another future. If the
/// old future has already completed successfully with data as above, changing
/// configuration to a new future results in snapshot pairs of the form:
///
/// * `new WAsyncSnapshot<String>.withData(WConnectionState.none, 'data of first future')`
/// * `new WAsyncSnapshot<String>.withData(WConnectionState.waiting, 'data of second future')`
///
/// In general, the latter will be produced only when the new future is
/// non-null, and the former only when the old future is non-null.
///
/// A [SWFutureBuilder] behaves identically to a [SWStreamBuilder] configured with
/// `future?.asStream()`, except that snapshots with `WConnectionState.active`
/// may appear for the latter, depending on how the stream is implemented.
///
/// {@tool sample}
///
/// This sample shows a [SWFutureBuilder] configuring a text label to show the
/// state of an asynchronous calculation returning a string. Assume the
/// `_calculation` field is set by pressing a button elsewhere in the UI.
///
/// ```dart
/// WFutureBuilder<String>(
///   future: _calculation, // a previously-obtained Future<String> or null
///   builder: (BuildContext context, WAsyncSnapshot<String> snapshot) {
///     switch (snapshot.connectionState) {
///       case WConnectionState.none:
///         return Text('Press button to start.');
///       case WConnectionState.active:
///       case WConnectionState.waiting:
///         return Text('Awaiting result...');
///       case WConnectionState.done:
///         if (snapshot.hasError)
///           return Text('Error: ${snapshot.error}');
///         return Text('Result: ${snapshot.data}');
///     }
///     return null; // unreachable
///   },
/// )
/// ```
/// {@end-tool}
// TODO(ianh): remove unreachable code above once https://github.com/dart-lang/linter/issues/1141 is fixed
class SWFutureBuilder<T> extends StatefulWidget {
  /// Creates a widget that builds itself based on the latest snapshot of
  /// interaction with a [Future].
  ///
  /// The [builder] must not be null.
  const SWFutureBuilder({
    Key key,
    this.future,
    this.initialData,
    @required this.builder,
  }) : assert(builder != null),
        super(key: key);

  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null.
  ///
  /// If no future has yet completed, including in the case where [future] is
  /// null, the data provided to the [builder] will be set to [initialData].
  final Future<T> future;

  /// The build strategy currently used by this builder.
  ///
  /// The builder is provided with an [SWAsyncSnapshot] object whose
  /// [SWAsyncSnapshot.connectionState] property will be one of the following
  /// values:
  ///
  ///  * [WConnectionState.none]: [future] is null. The [SWAsyncSnapshot.data] will
  ///    be set to [initialData], unless a future has previously completed, in
  ///    which case the previous result persists.
  ///
  ///  * [WConnectionState.waiting]: [future] is not null, but has not yet
  ///    completed. The [WAsyncSnapshot.data] will be set to [initialData],
  ///    unless a future has previously completed, in which case the previous
  ///    result persists.
  ///
  ///  * [WConnectionState.done]: [future] is not null, and has completed. If the
  ///    future completed successfully, the [WAsyncSnapshot.data] will be set to
  ///    the value to which the future completed. If it completed with an error,
  ///    [WAsyncSnapshot.hasError] will be true and [WAsyncSnapshot.error] will be
  ///    set to the error object.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the snapshots provided until a
  /// non-null [future] has completed.
  ///
  /// If the future completes with an error, the data in the [SWAsyncSnapshot]
  /// provided to the [builder] will become null, regardless of [initialData].
  /// (The error itself will be available in [SWAsyncSnapshot.error], and
  /// [SWAsyncSnapshot.hasError] will be true.)
  final T initialData;

  @override
  State<SWFutureBuilder<T>> createState() => _SWFutureBuilderState<T>();
}

/// State for [SWFutureBuilder].
class _SWFutureBuilderState<T> extends State<SWFutureBuilder<T>> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object _activeCallbackIdentity;
  SWAsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = SWAsyncSnapshot<T>.withData(SWConnectionState.none, widget.initialData);
    _subscribe();
  }

  @override
  void didUpdateWidget(SWFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(SWConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _snapshot);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.future != null) {
      final Object callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;
      widget.future.then<void>((T data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = SWAsyncSnapshot<T>.withData(SWConnectionState.done, data);
          });
        }
      }, onError: (Object error) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = SWAsyncSnapshot<T>.withError(SWConnectionState.done, error);
          });
        }
      });
      _snapshot = _snapshot.inState(SWConnectionState.waiting);
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }
}
