/*  Audacious - Cross-platform multimedia player
 *  Copyright (C) 2008  Audacious development team.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; under version 3 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses>.
 *
 *  The Audacious team does not consider modular code linking to
 *  Audacious or using our public API to be a derived work.
 */

#ifndef AUDACIOUS_PREFERENCES_H
#define AUDACIOUS_PREFERENCES_H

typedef enum {
    WIDGET_NONE,
    WIDGET_CHK_BTN,
    WIDGET_LABEL,
    WIDGET_RADIO_BTN,
    WIDGET_SPIN_BTN,
    WIDGET_CUSTOM,           /* 'custom' widget, you hand back the widget you want to add --nenolod */
    WIDGET_FONT_BTN,
} WidgetType;

typedef enum {
    VALUE_INT,
    VALUE_FLOAT,
    VALUE_BOOLEAN,
} ValueType;

typedef struct {
    WidgetType type;         /* widget type */
    char *label;             /* widget title (for SPIN_BTN it's text left to widget) */
    gpointer cfg;            /* connected config value */
    void (*callback) (void); /* this func will be called after value change, can be NULL */
    char *tooltip;           /* widget tooltip, can be NULL */
    gboolean child;
    union {
        struct {
            gdouble min, max, step;
            char *right_label;      /* text right to widget */
        } spin_btn;

        GtkWidget *(*populate) (void); /* for WIDGET_CUSTOM --nenolod */
    } data;
    ValueType cfg_type;      /* connected value type */
} PreferencesWidget;

void create_widgets(GtkBox *box, PreferencesWidget *widgets, gint amt);

#endif /* AUDACIOUS_PREFERENCES_H */
