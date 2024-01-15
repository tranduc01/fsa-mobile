enum Role {
  Member,
  Contributor,
  Expert,
  Leader,
  Admin,
}

enum ExpertiseRequestStatus {
  Doing,
  Completed,
  WaitingForApproval,
  WaitingForExpert,
  Rejected,
  Canceled,
}

enum ExpertAssginStatus {
  Doing,
  Canceled,
  Expired,
  Completed,
}

enum AuctionStatus { Upcoming, Ongoing, StopHalfway, Ended }

enum WithdrawStatus { Sent, Processing, Done, Rejected, Canceled }

enum TransactionType {
  Withdraw,
  Deposit,
  PointEarned,
  PointSpent,
  PointRefund,
  PointFine
}
