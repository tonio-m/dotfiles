---
name: inbox-footnotes
description: Write footnotes for inbox notes in the notes vault, without touching the notes. Each footnote turns a loose, free-thinking note into its next action, with links, watch-outs, a route and suggested todos. Use when asked to review the inbox, write or refresh footnotes, or annotate inbox notes.
---

# Inbox footnotes

Inbox notes are free thinking. They are often too ambitious or too vague to act on as written. A footnote turns a note into the next concrete step. It sits next to the note and is never written into it.

## Files

- Inbox note: `000_inbox/<name>.md`. Footnote: `_agents/footnotes/<name>.md`, with the same filename.
- Never edit, rename or delete the inbox note.
- Write the whole footnote file each time; don't append to an old one.
- Skip notes whose footnote is newer than the note (compare modification times), unless asked to redo them.
- Delete footnotes whose inbox note no longer exists.
- The vault's own rules are in `_agents/context.md`. Read it first if it isn't already loaded.

## What goes in a footnote

Use the sections below in this order. Leave out any section that has nothing real to say.

1. **Next action.** Open with the smallest physical step the user can take right now: one verb and one object, doable in one sitting. Then list the steps after it, each as small. If the note is ambitious, cut it down to where to start. If it is ambiguous, pick the most likely meaning and say so in a few words. If two readings are equally likely, give the first step of each.
2. **Links.** Include these whenever the note involves an institution, shop, booking, ticket, appointment or website. Link directly to the page where the action happens (the booking page, not the homepage), with a few words on what it's for. Find links with web search and prefer official domains over resellers. Never make up a URL: if you can't find one, say what to search for. Phone numbers count when booking is done by phone.
3. **Watch out.** Only include this when there is something real, for example:
   - deadlines, or closures and holidays on the planned dates
   - things that sell out, and lookalike or reseller sites
   - documents to bring, or prerequisites
   - clashes with other plans in the journal
   - plans that are more ambitious than the time allows
4. **Route.** Where the note goes when it's merged: `001_journal/<capture date from the filename>` for most notes, or `002_book notes/<book>` for reading notes.
5. **Todos.** Checkbox lines the user can paste into a journal note, grouped by the day they belong to. Today's journal tasks show up as reminders on the index page. Use future dates for steps that belong later, such as buying tickets before they sell out or checking in the day before a flight.

## Style

- Write short bullets. Don't summarise the note, add praise or encourage.
- Write the footnote in English. Write todo lines in the note's own language, since they go into the journal.
- Check every weekday and date by calculating it, not from memory. Mark guesses with "(guess)".
- Facts you got from search should come with their link. Facts from memory should say "check before relying on it".

## Example

```markdown
**Next action:** book the flights. Everything else depends on the dates.

1. Search flights out on 5/12 and back on the morning of 9/12.
2. Book 4 nights of accommodation (5–9/12).
3. Buy the museum tickets for 7/12 on the official site.

**Links**
- [Museum tickets (official)](https://example.org/tickets): the only official sales site

**Watch out**
- The museum is closed on 8/12 (public holiday), so 7/12 is the right day.
- Free entry on 6/12 can't be booked online. Expect a queue at the ticket office.

**Route:** `001_journal/2026-11-23`

**Todos**
- `001_journal/2026-11-24`: `- [ ] comprar voo`
- `001_journal/2026-12-04`: `- [ ] fazer check-in do voo`
```
