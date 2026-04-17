import '../models/timeline_model.dart';
import '../models/vendor_model.dart';
import '../models/inventory_model.dart';
import '../models/role_definition_model.dart';
import '../models/venue_ticketing_model.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../models/event_model.dart';
import '../models/budget_model.dart';

class ContributionSuggestion {
  final ContributionType type;
  final Map<String, double>? suggestedAmounts; // e.g. {"Silver": 500}
  final List<String> paymentMethods;
  final String target; // "All members", "Only flats", etc.

  ContributionSuggestion({
    required this.type,
    this.suggestedAmounts,
    required this.paymentMethods,
    required this.target,
  });
}

class GuestSuggestion {
  final List<String> categories;
  final bool rsvpRequired;
  final int maxGuests;
  final List<String> metadataFields;

  GuestSuggestion({
    required this.categories,
    required this.rsvpRequired,
    required this.maxGuests,
    required this.metadataFields,
  });
}

class ExpenseSuggestion {
  final List<String> categories;
  final bool approvalRequired;

  ExpenseSuggestion({
    required this.categories,
    required this.approvalRequired,
  });
}

class EventTemplateService {
  static ExpenseSuggestion getSuggestedExpenseSettings(EventCategory category) {
    switch (category) {
      case EventCategory.corporate:
        return ExpenseSuggestion(
          categories: ['Logistics', 'Marketing', 'AV Services', 'Catering'],
          approvalRequired: true,
        );
      case EventCategory.communityAndCultural:
        return ExpenseSuggestion(
          categories: ['Decoration', 'Prasad/Food', 'Artist Fees', 'Rentals'],
          approvalRequired: true,
        );
      case EventCategory.socialAndPersonal:
        return ExpenseSuggestion(
          categories: ['Venue', 'Catering', 'Photography', 'Decor'],
          approvalRequired: false,
        );
      default:
        return ExpenseSuggestion(
          categories: ['Miscellaneous'],
          approvalRequired: false,
        );
    }
  }

  static List<LocationModel> getSuggestedVenues(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.socialAndPersonal:
        return [
          LocationModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Primary Venue',
            address: 'To be specified',
            parkingInfo: 'Available on-site for up to 50 vehicles.',
            instructions: 'Enter via Main Gate North.',
          ),
        ];

      case EventCategory.communityAndCultural:
        return [
          LocationModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Main Ground',
            address: 'Central Park',
            parkingInfo: 'Public parking available across the street.',
            instructions: 'Follow signs for Community Event.',
          ),
          LocationModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Rehearsal Hall',
            address: 'Community Center, 2nd Floor',
            isMainVenue: false,
          ),
        ];

      default:
        return [
          LocationModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Main Venue',
            address: 'TBD',
          ),
        ];
    }
  }

  static List<TicketModel> getSuggestedTickets(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.corporate:
        return [
          TicketModel(id: uuid.v4(), eventId: eventId, title: 'Standard Access', price: 999, capacity: 200),
          TicketModel(id: uuid.v4(), eventId: eventId, title: 'VIP / Executive', price: 2499, capacity: 50),
        ];

      case EventCategory.socialAndPersonal:
        return [
          TicketModel(id: uuid.v4(), eventId: eventId, title: 'Regular Entry', price: 0, capacity: 100),
        ];

      case EventCategory.communityAndCultural:
        return [
          TicketModel(id: uuid.v4(), eventId: eventId, title: 'General Admission', price: 500, capacity: 500),
          TicketModel(id: uuid.v4(), eventId: eventId, title: 'Student Discount', price: 200, capacity: 200),
        ];

      default:
        return [
          TicketModel(id: uuid.v4(), eventId: eventId, title: 'Regular Ticket', price: 0, capacity: 100),
        ];
    }
  }

  static List<RoleDefinitionModel> getSuggestedRoles(EventCategory category) {
    // Keep templates flexible; start empty and let creators define roles.
    return const [];
  }

  static List<InventoryItemModel> getSuggestedInventory(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.socialAndPersonal:
        return [
          InventoryItemModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Bottled Water (500ml)',
            quantity: 100,
            unit: 'bottles',
            category: 'Food & Beverage',
            estimatedCost: 1500,
            responsibleRole: 'Food Manager',
          ),
          InventoryItemModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Decorative Flowers (Local)',
            quantity: 50,
            unit: 'bouquets',
            category: 'Decoration',
            estimatedCost: 3000,
            responsibleRole: 'Decorator',
          ),
          InventoryItemModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Paper Plates & Napkins',
            quantity: 200,
            unit: 'sets',
            category: 'Supplies',
            estimatedCost: 1000,
            responsibleRole: 'Food Manager',
          ),
        ];

      case EventCategory.communityAndCultural:
        return [
          InventoryItemModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Rice (Basmati)',
            quantity: 25,
            unit: 'kg',
            category: 'Food Supplies',
            estimatedCost: 2500,
            responsibleRole: 'Food Manager',
          ),
          InventoryItemModel(
            id: uuid.v4(),
            eventId: eventId,
            name: 'Loudspeakers / Mic Set',
            quantity: 1,
            unit: 'set',
            category: 'AV Equipment',
            estimatedCost: 0, // Assume rental/vendor
            responsibleRole: 'Logistics',
          ),
        ];

      default:
        return [];
    }
  }

  static List<VendorModel> getSuggestedVendors(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.socialAndPersonal:
        return [
          VendorModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Catering Service',
            role: 'Food & Beverage',
            selectionCriteria: 'Experience with buffet, reviews for hygiene, per-plate cost.',
            suggestions: 'Look for local caterers with at least 4.5 star ratings.',
          ),
          VendorModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Event Decorator',
            role: 'Venue Decoration',
            selectionCriteria: 'Portfolio of previous work, ability to provide lighting.',
          ),
        ];
      case EventCategory.communityAndCultural:
        return [
          VendorModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Sound & Stage Provider',
            role: 'Equipment Rental',
            selectionCriteria: 'Quality of speakers, backup power availability.',
          ),
          VendorModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Security / Management',
            role: 'Crowd Control',
            selectionCriteria: 'Certified personnel, experience with large gatherings.',
          ),
        ];
      default:
        return [];
    }
  }

  static List<TimelineItemModel> getSuggestedTimeline(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.socialAndPersonal:
        return [
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Send Final Reminders',
            phase: TimelinePhase.preEvent,
            timeOrOffset: 'T-2 days',
            description: 'Send RSVP and timing reminders to all guests.',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Guest Arrival & Welcome',
            phase: TimelinePhase.eventDay,
            timeOrOffset: '12:00 PM',
            description: 'Welcome drinks and registrations.',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Lunch / Buffet Starts',
            phase: TimelinePhase.eventDay,
            timeOrOffset: '1:30 PM',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Cake Cutting / Speeches',
            phase: TimelinePhase.eventDay,
            timeOrOffset: '3:00 PM',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Share Event Photos',
            phase: TimelinePhase.postEvent,
            timeOrOffset: 'T+1 day',
            description: 'Upload group photos to the event gallery.',
          ),
        ];

      case EventCategory.communityAndCultural:
        return [
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Stage & Tent Setup',
            phase: TimelinePhase.preEvent,
            timeOrOffset: 'T-1 day',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Inauguration Ceremony',
            phase: TimelinePhase.eventDay,
            timeOrOffset: '9:00 AM',
            description: 'Lamp lighting and welcome address.',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Main Cultural Event',
            phase: TimelinePhase.eventDay,
            timeOrOffset: '10:30 AM',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Awards & Prize Distribution',
            phase: TimelinePhase.eventDay,
            timeOrOffset: '4:00 PM',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Cleanup Drive',
            phase: TimelinePhase.postEvent,
            timeOrOffset: 'T+1 day',
            description: 'Volunteers and team to clear the venue.',
          ),
        ];

      default:
        return [
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Event Commencement',
            phase: TimelinePhase.eventDay,
            timeOrOffset: 'Time-0',
          ),
          TimelineItemModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Event Closing',
            phase: TimelinePhase.eventDay,
            timeOrOffset: 'Time+3 hrs',
          ),
        ];
    }
  }

  static GuestSuggestion getSuggestedGuestSettings(EventCategory category) {
    switch (category) {
      case EventCategory.socialAndPersonal:
        return GuestSuggestion(
          categories: ['Family', 'Friends', 'Colleagues'],
          rsvpRequired: true,
          maxGuests: 50,
          metadataFields: ['Food Preference (Veg/Non-Veg)', 'Allergies'],
        );
      case EventCategory.communityAndCultural:
        return GuestSuggestion(
          categories: ['Local Residents', 'Special Guests', 'Volunteers'],
          rsvpRequired: false,
          maxGuests: 500,
          metadataFields: ['Unit/House Number'],
        );
      case EventCategory.corporate:
        return GuestSuggestion(
          categories: ['Employees', 'VIP Clients', 'Board Members'],
          rsvpRequired: true,
          maxGuests: 200,
          metadataFields: ['Department', 'Transportation Req.'],
        );
      default:
        return GuestSuggestion(
          categories: ['Attendees'],
          rsvpRequired: false,
          maxGuests: 100,
          metadataFields: [],
        );
    }
  }

  static ContributionSuggestion getSuggestedContribution(EventCategory category) {
    switch (category) {
      case EventCategory.socialAndPersonal:
        return ContributionSuggestion(
          type: ContributionType.voluntary,
          paymentMethods: ['UPI', 'Cash'],
          target: 'Friends & Family',
        );
      case EventCategory.communityAndCultural:
        return ContributionSuggestion(
          type: ContributionType.fixed,
          suggestedAmounts: {'Per Unit': 1000},
          paymentMethods: ['UPI', 'Bank Transfer'],
          target: 'All Registered Members',
        );
      case EventCategory.corporate:
        return ContributionSuggestion(
          type: ContributionType.tierBased,
          suggestedAmounts: {'Platinum': 50000, 'Gold': 25000, 'Silver': 10000},
          paymentMethods: ['Bank Transfer', 'Corporate Cheque'],
          target: 'Corporate Partners',
        );
      default:
        return ContributionSuggestion(
          type: ContributionType.voluntary,
          paymentMethods: ['Cash'],
          target: 'All Participants',
        );
    }
  }

  static List<TaskModel> getSuggestedTasks(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.socialAndPersonal:
        return [
          // Pre-event
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Finalize Guest List',
            description: 'Identify and list all guests to be invited.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-30 days',
            role: 'Organizer',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Book Venue',
            description: 'Search, visit, and confirm the venue booking with advance payment.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-25 days',
            role: 'Organizer',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Finalize Catering Menu',
            description: 'Confirm the food items and guest count with the caterer.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-10 days',
            role: 'Food Manager',
          ),
          // Event Day
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Venue Setup & Decoration',
            description: 'Ensure the venue is decorated and seating is arranged.',
            status: TaskStatus.pending,
            phase: TaskPhase.eventDay,
            dueOffset: 'Event Morning',
            role: 'Setup Team',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Guest Greeting & Management',
            description: 'Welcome guests and guide them to their seats.',
            status: TaskStatus.pending,
            phase: TaskPhase.eventDay,
            dueOffset: 'Event Start',
            role: 'Host',
          ),
          // Post-event
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Venue Handover & Cleanup',
            description: 'Clear the venue and return keys/equipment.',
            status: TaskStatus.pending,
            phase: TaskPhase.postEvent,
            dueOffset: 'T+1 day',
            role: 'Logistics',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Final Payment Settlements',
            description: 'Pay all vendors and balance event accounts.',
            status: TaskStatus.pending,
            phase: TaskPhase.postEvent,
            dueOffset: 'T+3 days',
            role: 'Treasurer',
          ),
        ];

      case EventCategory.communityAndCultural:
        return [
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Permit & Permission Procurement',
            description: 'Obtain necessary local body approvals for the community event.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-45 days',
            role: 'Admin/Legal',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Volunteer Recruitment',
            description: 'Form teams for various event responsibilities.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-30 days',
            role: 'Organizer',
          ),
           TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Collection of Contributions',
            description: 'Follow up with members for event funds.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-15 days',
            role: 'Treasurer',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Cultural Program Rehearsals',
            description: 'Final rehearsal for all performers.',
            status: TaskStatus.pending,
            phase: TaskPhase.eventDay,
            dueOffset: 'T-1 day',
            role: 'Cultural Lead',
          ),
        ];

      default:
        return [
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Define Event Goals',
            description: 'Clarify the objective and scale of the event.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-20 days',
            role: 'Organizer',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Budget Approval',
            description: 'Get initial budget estimates approved.',
            status: TaskStatus.pending,
            phase: TaskPhase.preEvent,
            dueOffset: 'T-15 days',
            role: 'Treasurer',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Event Execution',
            description: 'Main event activities.',
            status: TaskStatus.pending,
            phase: TaskPhase.eventDay,
            dueOffset: 'T-0',
            role: 'Lead',
          ),
          TaskModel(
            id: uuid.v4(),
            eventId: eventId,
            title: 'Impact Report',
            description: 'Summarize the event success and feedback.',
            status: TaskStatus.pending,
            phase: TaskPhase.postEvent,
            dueOffset: 'T+7 days',
            role: 'Organizer',
          ),
        ];
    }
  }

  static List<BudgetItemModel> getSuggestedBudget(String eventId, EventCategory category) {
    final uuid = const Uuid();
    
    switch (category) {
      case EventCategory.socialAndPersonal:
        return [
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Venue',
            title: 'Venue Rental',
            estimatedCost: 15000,
            isMandatory: true,
          ),
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Food',
            title: 'Catering (per head)',
            estimatedCost: 20000,
            isMandatory: true,
          ),
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Decoration',
            title: 'Stage & Lighting',
            estimatedCost: 10000,
            isMandatory: true,
          ),
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Miscellaneous',
            title: 'Photography',
            estimatedCost: 5000,
            isMandatory: false,
          ),
        ];
      case EventCategory.communityAndCultural:
        return [
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Venue',
            title: 'Community Hall / Ground',
            estimatedCost: 5000,
            isMandatory: true,
          ),
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Food',
            title: 'Prasad / Community Meal',
            estimatedCost: 10000,
            isMandatory: true,
          ),
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Decoration',
            title: 'Street Lighting & Floral',
            estimatedCost: 15000,
            isMandatory: true,
          ),
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Miscellaneous',
            title: 'Sound System / DJ',
            estimatedCost: 3000,
            isMandatory: true,
          ),
        ];
      default:
        return [
          BudgetItemModel(
            id: uuid.v4(),
            eventId: eventId,
            category: 'Miscellaneous',
            title: 'General Supplies',
            estimatedCost: 2000,
            isMandatory: true,
          ),
        ];
    }
  }
}
