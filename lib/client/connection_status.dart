enum ConnectionStatus {
  NotConnected,
  RequestingSession,
  ConnectingToPeer,
  TestingPipe,
  Connected,

  BrokenPipe,
  SessionNotFound,
  UnknownError,

  OfferingHelp,
  HelpWanted,
  HelpNotWanted,
}