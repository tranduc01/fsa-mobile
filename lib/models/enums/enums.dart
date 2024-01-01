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
  Rejected
}

enum ExpertAssginStatus {
  Doing,
  Canceled,
  Expired,
  Completed,
}

enum AuctionStatus { Upcoming, Ongoing, StopHalfway, Ended }

enum WithdrawStatus { Sent, Processing, Done, Rejected, Canceled }
