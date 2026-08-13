import '../../../domain/entities/commitment_entity.dart';

/// Where a commitment sits in its payment cycle right now.
enum CommitmentDueStatus {
  overdue,   // next due date has passed
  dueSoon,   // due within 7 days
  upcoming,  // due later than 7 days out
  ended,     // endDate has passed (e.g., finished jam'iya, closed loan)
}

class CommitmentDue {
  final CommitmentEntity commitment;
  final DateTime nextDueDate;
  final CommitmentDueStatus status;

  const CommitmentDue({
    required this.commitment,
    required this.nextDueDate,
    required this.status,
  });
}

/// Computes the next due date + status for [c] at [now]. Pure — no
/// storage, so recomputed on each render.
CommitmentDue computeCommitmentDue(CommitmentEntity c, DateTime now) {
  // If the commitment already ended, expose that so the UI can grey it out.
  if (c.endDate != null && c.endDate!.isBefore(now)) {
    return CommitmentDue(
      commitment: c,
      nextDueDate: c.endDate!,
      status: CommitmentDueStatus.ended,
    );
  }

  final base = c.lastPaidDate ?? c.startDate;
  DateTime next = _advance(base, c.frequency);

  // If never paid, the next due IS the start date itself — don't advance
  // past it just because a period has elapsed.
  if (c.lastPaidDate == null) {
    next = c.startDate;
  }

  // Fast-forward past any missed cycles so `next` is always the current
  // outstanding due (not something months in the past).
  while (c.lastPaidDate != null && next.isBefore(now.subtract(_period(c.frequency)))) {
    next = _advance(next, c.frequency);
  }

  final status = _classify(next, now);
  return CommitmentDue(commitment: c, nextDueDate: next, status: status);
}

CommitmentDueStatus _classify(DateTime nextDue, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(nextDue.year, nextDue.month, nextDue.day);
  final diffDays = due.difference(today).inDays;
  if (diffDays < 0) return CommitmentDueStatus.overdue;
  if (diffDays <= 7) return CommitmentDueStatus.dueSoon;
  return CommitmentDueStatus.upcoming;
}

DateTime _advance(DateTime from, CommitmentFrequency f) {
  switch (f) {
    case CommitmentFrequency.weekly:
      return from.add(const Duration(days: 7));
    case CommitmentFrequency.monthly:
      return DateTime(from.year, from.month + 1, from.day);
    case CommitmentFrequency.quarterly:
      return DateTime(from.year, from.month + 3, from.day);
    case CommitmentFrequency.yearly:
      return DateTime(from.year + 1, from.month, from.day);
  }
}

Duration _period(CommitmentFrequency f) {
  switch (f) {
    case CommitmentFrequency.weekly:
      return const Duration(days: 7);
    case CommitmentFrequency.monthly:
      return const Duration(days: 30);
    case CommitmentFrequency.quarterly:
      return const Duration(days: 90);
    case CommitmentFrequency.yearly:
      return const Duration(days: 365);
  }
}
